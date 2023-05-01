use std::path::Path;
use std::process::Command;

use anyhow::anyhow;
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
        if !Path::new(&self.script_path).is_file() {
            return Err(anyhow!(format!("{} is not a valid file", self.script_path)));
        }

        // TODO: don't print script output to stdout/stderr
        let status = Command::new(&self.command)
            .arg(&self.script_path)
            .spawn()
            .or(Err(anyhow!("failed to start command {}", self.command)))?
            .wait()?;
        if !status.success() {
            return Err(anyhow!("failed to run {}", self.script_path));
        }
        Ok(())
    }
}
