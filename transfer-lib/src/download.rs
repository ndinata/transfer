use std::fs::{self, File};
use std::io::Write;
use std::process::Command;

use curl::easy::Easy;

/// `DownloadProgress = (downloaded, total_size)`
type DownloadProgress = (u64, u64);

type Result<T, E = DownloadError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum DownloadError {
    #[error("`{0}` is not a valid URL")]
    InvalidUrl(String),

    #[error("`{0}` failed to run successfully")]
    CannotRun(String),

    #[error(transparent)]
    CurlError(#[from] curl::Error),

    #[error(transparent)]
    IoError(#[from] std::io::Error),
}

pub struct Downloader {
    client: Easy,
}

impl Downloader {
    pub fn init() -> Result<Downloader> {
        let mut client = Easy::new();
        client.fail_on_error(true)?;
        client.follow_location(true)?;
        client.progress(true)?;

        Ok(Downloader { client })
    }

    pub fn download<F: Fn(DownloadProgress)>(
        &mut self,
        from_url: &str,
        to_path: &str,
        dl_progress_cb: F,
    ) -> Result<()> {
        self.client.url(from_url)?;

        let mut tranfer = self.client.transfer();
        tranfer.progress_function(|total_dl, downloaded, _, _| {
            let (total_dl, downloaded) = (total_dl as u64, downloaded as u64);
            if total_dl > 0 && downloaded < total_dl {
                let percentage = downloaded * 100 / total_dl;
                eprintln!("Downloaded: {}% ({}/{}B)", percentage, downloaded, total_dl);
                dl_progress_cb((downloaded, total_dl));
            }

            true
        })?;

        let mut file = File::create(to_path)?;
        tranfer.write_function(move |data| {
            file.write_all(data).unwrap();
            Ok(data.len())
        })?;

        eprintln!();
        eprintln!("Downloading `{from_url}`...");
        tranfer.perform()?;

        // let res = self.client.get(from_url).send().await?;
        // let total_size = res.content_length();

        // if let Some(total) = total_size {
        //     println!("Download starting, total size is {total}B.");
        // } else {
        //     println!("Download starting.");
        // }

        // let mut downloaded = 0;
        // let mut stream = res.bytes_stream();

        // while let Some(item) = stream.next().await {
        //     let chunk = item?;
        //     file.write_all(&chunk)?;

        //     let new = match total_size {
        //         Some(total) => cmp::min(downloaded + (chunk.len() as u64), total),
        //         None => downloaded + (chunk.len() as u64),
        //     };
        //     downloaded = new;

        //     dl_progress_cb((downloaded, total_size));
        // }

        eprintln!("Downloaded `{}` to `{}`.", from_url, to_path);
        Ok(())
    }

    pub fn download_and_source<F: Fn(DownloadProgress)>(
        &mut self,
        from_url: &str,
        dl_progress_cb: F,
    ) -> Result<()> {
        let filename = from_url
            .split('/')
            .last()
            .ok_or(DownloadError::InvalidUrl(from_url.to_string()))?;

        self.download(from_url, filename, dl_progress_cb)?;

        eprintln!("Running `{filename}`...");

        let status = Command::new("sh")
            .arg("-c")
            .arg(format!("source {}", filename))
            .spawn()
            .or(Err(DownloadError::CannotRun("sh".to_string())))?
            .wait()?;
        if !status.success() {
            return Err(DownloadError::CannotRun(filename.to_string()));
        }

        eprintln!("Done running `{filename}`, deleting the file.");
        fs::remove_file(filename)?;

        Ok(())
    }

    // fn get_filename_from_url(&self, url: &str) -> Result<String> {
    //     let url = Url::parse(url).or(Err(DownloadError::InvalidUrl(url.to_string())))?;
    //     let filename = url
    //         .path_segments()
    //         .ok_or(DownloadError::InvalidUrl(url.to_string()))?
    //         .last()
    //         .unwrap();

    //     Ok(filename.to_owned())
    // }
}
