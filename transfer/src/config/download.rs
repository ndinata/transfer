use std::fs::File;
use std::io::Write;
use std::path::Path;

use anyhow::{ensure, Result};
use curl::easy::Easy;
use serde::Deserialize;

/// `DownloadProgress = (downloaded, total_size)`
type DownloadProgress = (u64, u64);

/// The configuration schema for downloading files either to store or to run.
#[derive(Debug, Deserialize)]
pub struct Downloadable {
    #[serde(skip, default = "init_client")]
    client: Easy,

    pub url: String,
    pub to_path: String,
}

impl PartialEq for Downloadable {
    fn eq(&self, other: &Self) -> bool {
        self.url == other.url && self.to_path == other.to_path
    }
}

/// Initialises and returns the `curl` wrapper for downloading files. Also sets
/// the following `curl` behaviours to `true`:
/// - `fail_on_error`
/// - `follow_location`
/// - `progress`
///
/// # Panics
/// This function panics if setting any of those behaviours fails.
fn init_client() -> Easy {
    let mut client = Easy::new();
    client
        .fail_on_error(true)
        .and_then(|_| client.follow_location(true))
        .and_then(|_| client.progress(true))
        .expect("initialising curl flags should be successful");
    client
}

impl Downloadable {
    /// This function is not meant to be called directly (although it can be),
    /// as it's intended only for setting up test cases.
    pub fn new(url: String, to_path: String) -> Self {
        Downloadable {
            client: init_client(),
            url,
            to_path,
        }
    }

    /// If `self.to_path` is defined, downloads the file specified in `self.url`
    /// and store it in that path. Otherwise, treats the file as a script and
    /// runs it after it's downloaded.
    ///
    /// # Errors
    /// This function returns an error when both `self.to_path` and `self.run` are
    /// undefined, as `self.url` is supposed to be either stored or run.
    ///
    /// All errors returned from the download process are also propagated.
    // pub fn download<F: Fn(DownloadProgress)>(&mut self, dl_progress_cb: F) -> Result<()> {
    //     // Either `to_path` or `run: true` has to be set
    //     if self.to_path.is_none() && (self.run.is_none() || !self.run.unwrap()) {
    //         return Err(anyhow!(
    //             "either `to` or `run` has to be defined in a `download` object"
    //         ));
    //     }

    //     if self.to_path.is_some() {
    //         self.download_to_file(&self.to_path.clone().unwrap(), dl_progress_cb)?;
    //     } else {
    //         self.download_and_source(dl_progress_cb)?;
    //     }
    //     Ok(())
    // }

    /// Downloads the file in `self.url` to the target path (synchronously),
    /// creating the dir first if it doesn't exist.
    ///
    /// # Errors
    /// This function propagates any errors returned from creating the dir,
    /// downloading the file, and writing the file.
    pub fn download_to_file<F: Fn(DownloadProgress)>(&mut self, progress_cb: F) -> Result<()> {
        let to_path = Path::new(&self.to_path);

        self.client.url(&self.url)?;

        let mut transfer = self.client.transfer();
        transfer.progress_function(|total_dl, downloaded, _, _| {
            let (total_dl, downloaded) = (total_dl as u64, downloaded as u64);
            if total_dl > 0 && downloaded <= total_dl {
                progress_cb((downloaded, total_dl));
            }
            true
        })?;

        ensure!(
            to_path.parent().is_some(),
            "cannot get parent path from {}",
            to_path.display()
        );
        crate::dir::create_dir(to_path.parent().unwrap())?;

        let mut file = File::create(to_path)?;

        transfer.write_function(move |data| {
            file.write_all(data)
                .expect("transfer should have received data successfully");
            Ok(data.len())
        })?;
        transfer.perform()?;
        Ok(())
    }

    // fn download_and_source<F: Fn(DownloadProgress)>(&mut self, dl_progress_cb: F) -> Result<()> {
    //     let from = self.url.clone();
    //     let filename = from
    //         .split('/')
    //         .last()
    //         .ok_or(DownloadError::InvalidUrl(from.to_string()))?;

    //     self.download_to_file(filename, dl_progress_cb)?;

    //     eprintln!("Running `{filename}`...");
    //     let status = Command::new("sh")
    //         .arg("-c")
    //         .arg(format!("source {}", filename))
    //         .spawn()
    //         .or(Err(DownloadError::CannotRun("sh".to_string())))?
    //         .wait()?;
    //     if !status.success() {
    //         return Err(DownloadError::CannotRun(filename.to_string()));
    //     }

    //     eprintln!("Done running `{filename}`, deleting the file.");
    //     fs::remove_file(filename)?;
    //     Ok(())
    // }

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
