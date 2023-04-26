use std::fs;

use serde::Deserialize;

use crate::{Brew, Copyable, Downloadable, Remindable, Runnable};

#[derive(thiserror::Error, Debug)]
pub enum ConfigError {
    #[error("config file `{0}` is improperly formatted")]
    InvalidFormat(String),

    #[error("path is not a valid config file")]
    InvalidFilePath(#[from] std::io::Error),
}

/// Tries to parse the TOML file at `file_path` and serialise it into the schema
/// defined in `Config`.
///
/// ## Errors
/// This function returns an error if:
/// - the file at `file_path` cannot be read into a `String`, or
/// - the file doesn't conform to the schema defined in `Config`
pub fn parse_config(file_path: &str) -> Result<Config, ConfigError> {
    let content = fs::read_to_string(file_path)?;
    let config: Config =
        toml::from_str(&content).or(Err(ConfigError::InvalidFormat(file_path.to_string())))?;
    Ok(config)
}

/// Configuration schema for adjusting the behaviour of the `transfer` program.
#[derive(Debug, Deserialize)]
pub struct Config {
    /// Homebrew-related items (taps, formulae, casks).
    pub brew: Brew,

    /// Files to copy.
    pub copy: Vec<Copyable>,

    /// Files to download.
    pub download: Vec<Downloadable>,

    /// Scripts to run.
    pub run: Vec<Runnable>,

    /// Reminders to be displayed.
    pub reminders: Vec<Remindable>,
}
