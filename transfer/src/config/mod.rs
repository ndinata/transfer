pub mod brew;
pub mod copy;
pub mod download;
pub mod remind;
pub mod run;

use std::fs;
use std::path::Path;

use anyhow::Result;
use serde::Deserialize;

/// Parses the TOML file at `file_path` and serialises it into the schema
/// defined in `Config`.
///
/// # Errors
/// This function returns an error if:
/// - the file at `file_path` cannot be read, or
/// - the file doesn't match the schema defined in `Config`
pub fn parse_config<P: AsRef<Path>>(file_path: P) -> Result<Config> {
    let content = fs::read_to_string(file_path)?;
    let config: Config = toml::from_str(&content)?;
    Ok(config)
}

/// Configuration schema for adjusting the behaviour of the program.
#[derive(Debug, Deserialize)]
pub struct Config {
    /// Files to copy.
    pub copy: Vec<copy::Copyable>,

    /// Files to download.
    pub download: Vec<download::Downloadable>,

    /// Scripts to run.
    pub run: Vec<run::Runnable>,

    /// Reminders to be displayed.
    pub reminders: Vec<remind::Remindable>,
}
