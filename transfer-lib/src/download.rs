use std::fs::{self, File};
use std::io::Write;
use std::process::Command;

use curl::easy::Easy;
use serde::Deserialize;

/// `DownloadProgress = (downloaded, total_size)`
type DownloadProgress = (u64, u64);

type Result<T, E = DownloadError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum DownloadError {
    #[error("`{0}` is not a valid URL")]
    InvalidUrl(String),

    #[error("`{0}` failed to run successfully")]
    CannotRun(String),

    #[error("either `to` or `run` has to be defined in `download`")]
    InvalidItem,

    #[error(transparent)]
    CurlError(#[from] curl::Error),

    #[error(transparent)]
    IoError(#[from] std::io::Error),
}

#[derive(Debug, Deserialize)]
pub struct Downloadable {
    #[serde(skip, default = "init_client")]
    client: Easy,

    pub from: String,
    pub to: Option<String>,
    pub run: Option<bool>,
}

fn init_client() -> Easy {
    let mut client = Easy::new();
    if let Err(e) = client
        .fail_on_error(true)
        .and_then(|_| client.follow_location(true))
        .and_then(|_| client.progress(true))
    {
        panic!("{e}");
    }
    client
}

impl Downloadable {
    pub fn download<F: Fn(DownloadProgress)>(&mut self, dl_progress_cb: F) -> Result<()> {
        // Either `to` or `run: true` has to be set
        if self.to.is_none() && self.run.is_none() && !self.run.unwrap() {
            return Err(DownloadError::InvalidItem);
        }

        if self.to.is_some() {
            self.download_to_file(&self.to.clone().unwrap(), dl_progress_cb)?;
        } else {
            self.download_and_source(dl_progress_cb)?;
        }
        Ok(())
    }

    fn download_to_file<F: Fn(DownloadProgress)>(
        &mut self,
        to: &str,
        progress_cb: F,
    ) -> Result<()> {
        self.client.url(&self.from)?;

        let mut transfer = self.client.transfer();
        transfer.progress_function(|total_dl, downloaded, _, _| {
            let (total_dl, downloaded) = (total_dl as u64, downloaded as u64);
            if total_dl > 0 && downloaded < total_dl {
                let percentage = downloaded * 100 / total_dl;
                eprintln!("Downloaded: {}% ({}/{}B)", percentage, downloaded, total_dl);
                progress_cb((downloaded, total_dl));
            }
            true
        })?;

        let mut file = File::create(to)?;
        transfer.write_function(move |data| {
            file.write_all(data).unwrap();
            Ok(data.len())
        })?;

        eprintln!();
        eprintln!("Downloading `{}`...", self.from);
        transfer.perform()?;
        eprintln!("Downloaded `{}` to `{}`.", self.from, to);
        Ok(())
    }

    pub fn download_and_source<F: Fn(DownloadProgress)>(
        &mut self,
        dl_progress_cb: F,
    ) -> Result<()> {
        let from = self.from.clone();
        let filename = from
            .split('/')
            .last()
            .ok_or(DownloadError::InvalidUrl(from.to_string()))?;

        self.download_to_file(filename, dl_progress_cb)?;

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
