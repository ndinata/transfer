use std::cmp;
use std::fs::{self, File};
use std::io::Write;
use std::process::Command;

use futures_util::StreamExt;
use reqwest::{Client, Url};

/// `DownloadProgress = (downloaded, Option<total_size>)`
type DownloadProgress = (u64, Option<u64>);

type Result<T, E = DownloadError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum DownloadError {
    #[error("`{0}` is not a valid URL")]
    InvalidUrl(String),

    #[error("`{0}` failed to run successfully")]
    CannotRun(String),

    #[error(transparent)]
    RequestError(#[from] reqwest::Error),

    #[error(transparent)]
    IoError(#[from] std::io::Error),
}

pub struct Downloader {
    client: Client,
}

impl Default for Downloader {
    fn default() -> Self {
        Self::new()
    }
}

impl Downloader {
    pub fn new() -> Downloader {
        Downloader {
            client: Client::new(),
        }
    }

    pub async fn download<F: Fn(DownloadProgress)>(
        &self,
        from_url: &str,
        to_path: &str,
        dl_progress_cb: F,
    ) -> Result<File> {
        // reference:
        // https://gist.github.com/giuliano-oliveira/4d11d6b3bb003dba3a1b53f43d81b30d

        let res = self.client.get(from_url).send().await?;
        let total_size = res.content_length();

        if let Some(total) = total_size {
            println!("Download starting, total size is {total}B.");
        } else {
            println!("Download starting.");
        }

        let mut file = File::create(to_path)?;
        let mut downloaded = 0;
        let mut stream = res.bytes_stream();

        while let Some(item) = stream.next().await {
            let chunk = item?;
            file.write_all(&chunk)?;

            let new = match total_size {
                Some(total) => cmp::min(downloaded + (chunk.len() as u64), total),
                None => downloaded + (chunk.len() as u64),
            };
            downloaded = new;

            dl_progress_cb((downloaded, total_size));
        }

        println!("Downloaded `{}` to `{}`.", from_url, to_path);
        Ok(file)
    }

    pub async fn download_and_source<F: Fn(DownloadProgress)>(
        &self,
        from_url: &str,
        dl_progress_cb: F,
    ) -> Result<()> {
        let filename = self.get_filename_from_url(from_url)?;
        self.download(from_url, &filename, dl_progress_cb).await?;

        println!("Running `{filename}`, hang on...");

        let status = Command::new("sh")
            .arg("-c")
            .arg(format!("source {}", filename))
            .spawn()
            .or(Err(DownloadError::CannotRun("sh".to_string())))?
            .wait()?;
        if !status.success() {
            return Err(DownloadError::CannotRun(filename));
        }

        println!("Done running `{filename}`, deleting the file.");
        fs::remove_file(filename)?;

        Ok(())
    }

    fn get_filename_from_url(&self, url: &str) -> Result<String> {
        let url = Url::parse(url).or(Err(DownloadError::InvalidUrl(url.to_string())))?;

        let filename = url
            .path_segments()
            .ok_or(DownloadError::InvalidUrl(url.to_string()))?
            .last()
            .unwrap();

        Ok(filename.to_owned())
    }
}
