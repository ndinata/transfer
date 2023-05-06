use std::fs::File;
use std::io::Write;
use std::path::Path;

use anyhow::{ensure, Result};
use curl::easy::Easy;
use serde::Deserialize;

/// `DownloadProgress = (downloaded, total_size)`
type DownloadProgress = (u64, u64);

/// The configuration schema for downloading files to be stored.
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
/// the following `curl` flags to `true`:
/// - `fail_on_error`
/// - `follow_location`
/// - `progress`
///
/// # Panics
/// This function panics if setting any of those flags fails.
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
    /// Downloads the file in `self.url` to the target path (synchronously),
    /// creating the dir first if it doesn't exist.
    ///
    /// # Errors
    /// This function propagates any errors returned from creating the dir,
    /// downloading the file, and writing the file.
    pub fn download_to_file<F: Fn(DownloadProgress)>(&mut self, progress_cb: F) -> Result<()> {
        self.client.url(&self.url)?;

        let mut transfer = self.client.transfer();
        transfer.progress_function(|total_dl, downloaded, _, _| {
            let (total_dl, downloaded) = (total_dl as u64, downloaded as u64);
            if total_dl > 0 && downloaded <= total_dl {
                progress_cb((downloaded, total_dl));
            }
            true
        })?;

        let to_path = Path::new(&self.to_path);
        ensure!(
            to_path.parent().is_some(),
            "cannot get parent path from '{}'",
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
}
