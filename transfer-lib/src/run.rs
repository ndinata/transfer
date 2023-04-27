use std::path::Path;
use std::process::Command;

use serde::Deserialize;

#[derive(thiserror::Error, Debug)]
pub enum RunError {
    #[error("`{0}` is an invalid file path")]
    InvalidFile(String),

    #[error("`{0}` failed to run successfully")]
    FailedRun(String),

    #[error(transparent)]
    IoError(#[from] std::io::Error),
}

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
    pub fn run_script(&self) -> Result<(), RunError> {
        if !Path::new(&self.script_path).is_file() {
            return Err(RunError::InvalidFile(self.script_path.to_string()));
        }

        let status = Command::new(&self.command)
            .arg(&self.script_path)
            .spawn()
            .or(Err(RunError::FailedRun(self.command.to_string())))?
            .wait()?;
        if !status.success() {
            return Err(RunError::FailedRun(self.command.to_string()));
        }
        Ok(())
    }
}
