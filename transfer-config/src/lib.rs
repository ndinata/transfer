use serde::Deserialize;
use std::fs;

#[derive(thiserror::Error, Debug)]
pub enum ConfigError {
    #[error("config file `{0}` is improperly formatted")]
    InvalidFormat(String),

    #[error("path is not a valid config file")]
    InvalidFilePath(#[from] std::io::Error),
}

pub fn parse_config(file_path: &str) -> Result<Config, ConfigError> {
    let content = fs::read_to_string(file_path)?;
    let config: Config =
        toml::from_str(&content).or(Err(ConfigError::InvalidFormat(file_path.to_string())))?;
    Ok(config)
}

#[derive(Debug, Deserialize)]
pub struct Config {
    pub copy: Vec<ToCopy>,
    pub download: Vec<ToDownload>,
    pub run: Vec<ToRun>,
    pub reminders: Vec<ToRemind>,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
pub struct ToCopy {
    pub from: String,
    pub to: String,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
pub struct ToDownload {
    pub from: String,
    pub to: Option<String>,
    pub run: Option<bool>,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
pub struct ToRun {
    pub script_path: String,
    pub command: String,
    pub title: String,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
pub struct ToRemind {
    pub instruction: String,
    pub command: String,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_config_works() {
        let config: Config = parse_config("config_test.toml").unwrap();

        assert_eq!(
            config.copy,
            vec![ToCopy {
                from: String::from("dotfiles/git/.gitconfig"),
                to: String::from("~/Desktop/transfer-test/dotfiles/")
            }]
        );
        assert_eq!(
            config.download,
            vec![
                ToDownload {
                    from: "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
                        .to_string(),
                    to: Some("~/Desktop/transfer-test/downloads/plug.vim".to_string()),
                    run: None,
                },
                ToDownload {
                    from: "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish".to_string(),
                    to: None,
                    run: Some(true)
                }
            ]
        );
        assert_eq!(
            config.run,
            vec![ToRun {
                script_path: "scripts/macos.sh".to_string(),
                command: "bash".to_string(),
                title: "Configuring macOS".to_string()
            }]
        );
        assert_eq!(
            config.reminders,
            vec![ToRemind {
                instruction: "Set fish as default shell".to_string(),
                command: "chsh -s /opt/homebrew/bin/fish".to_string()
            }]
        )
    }
}
