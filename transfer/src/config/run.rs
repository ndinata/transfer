use std::process::Command;
use std::{path::Path, process::Stdio};

use anyhow::ensure;
use serde::Deserialize;

/// The configuration schema for running scripts.
#[derive(Debug, Deserialize, PartialEq)]
pub struct Runnable {
    pub script_path: String,
    pub command: String,
    pub title: String,
}

impl Runnable {
    /// Runs the script in `self.script_path` using `self.command`.
    ///
    /// # Errors
    /// This function returns an error if:
    /// - `self.script_path` isn't a valid file, or
    /// - running the script is unsuccessful
    pub fn run_script(&self) -> Result<(), anyhow::Error> {
        ensure!(
            Path::new(&self.script_path).is_file(),
            format!("{} is not a valid file", self.script_path)
        );

        let status = Command::new(&self.command)
            .arg(&self.script_path)
            .stderr(Stdio::null())
            .status()?;
        ensure!(
            status.success(),
            format!("{} didn't terminate successfully", self.script_path)
        );
        Ok(())
    }
}
