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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_config_works() {
        let config: Config = parse_config("config_test.toml").unwrap();

        assert_eq!(config.brew.taps, vec!["homebrew/bundle"]);
        assert_eq!(config.brew.formulae, vec!["bat", "git"]);

        // Verify that commented items are not included in the config object
        // ```
        // brew.casks = [
        //   # "postman",
        //   "slack",
        // ]
        // ```
        assert_eq!(config.brew.casks, vec!["slack"]);

        assert_eq!(
            config.copy,
            vec![Copyable {
                from: "dotfiles/git/.gitconfig".to_string(),
                to: "~/Desktop/transfer-test/dotfiles/".to_string()
            }]
        );
        assert_eq!(
            config.download,
            vec![
                Downloadable::new(
                    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
                        .to_string(),
                    Some("~/Desktop/transfer-test/downloads/plug.vim".to_string()),
                    None,
                ),
                Downloadable::new(
                    "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish".to_string(),
                    None,
                    Some(true)
                )
            ]
        );
        assert_eq!(
            config.run,
            vec![Runnable {
                script_path: "scripts/macos.sh".to_string(),
                command: "bash".to_string(),
                title: "Configuring macOS".to_string()
            }]
        );
        assert_eq!(
            config.reminders,
            vec![Remindable {
                instruction: "Set fish as default shell".to_string(),
                command: "chsh -s /opt/homebrew/bin/fish".to_string()
            }]
        )
    }
}
