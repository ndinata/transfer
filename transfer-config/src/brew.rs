use serde::Deserialize;
use xshell::{cmd, Shell};

type Result<T, E = BrewError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum BrewError {
    #[error(transparent)]
    ShellError(#[from] xshell::Error),
}

/// The configuration schema for installing Homebrew taps, formulae, and casks.
#[derive(Debug, Deserialize)]
pub struct Brew {
    #[serde(skip, default = "init_shell")]
    sh: Shell,

    pub taps: Vec<String>,
    pub formulae: Vec<String>,
    pub casks: Vec<String>,
}

/// Initialises and returns the shell instance for running shell commands.
///
/// # Panics
/// This function panics when the current dir in which it is run is inaccessible.
fn init_shell() -> Shell {
    Shell::new().expect("current dir should be able to be accessed")
}

/// `Progress = (current_count, total_count)`
type Progress = (usize, usize);

impl Brew {
    /// This function does three things in order after each step is successful:
    /// 1. Runs the script to install Homebrew non-interactively
    /// 2. Updates Homebrew
    /// 3. Turns off Homebrew analytics
    ///
    /// # Errors
    /// This function returns an error if any of those steps is unsuccessful.
    pub fn install_self(&self) -> Result<()> {
        const BREW_INSTALL_COMMAND: &str = "NONINTERACTIVE=1 /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"";
        cmd!(self.sh, "{BREW_INSTALL_COMMAND}").quiet().run()?;

        const BREW_UPDATE: &str = "brew update && brew upgrade";
        cmd!(self.sh, "{BREW_UPDATE}").quiet().run()?;

        const BREW_ANALYTICS_OFF: &str = "brew analytics off";
        cmd!(self.sh, "{BREW_ANALYTICS_OFF}").quiet().run()?;

        Ok(())
    }

    /// Runs `brew tap` on every tap in its `taps` field.
    ///
    /// # Errors
    /// This function returns an error if `brew tap` is unsuccessful.
    pub fn install_taps<F: Fn(Progress)>(&self, progress_cb: F) -> Result<()> {
        let total = self.taps.len();
        for (i, tap) in self.taps.iter().enumerate() {
            cmd!(self.sh, "brew tap {tap}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }

    /// Runs `brew install` on every formula in its `formulae` field.
    ///
    /// # Errors
    /// This function returns an error if `brew install` is unsuccessful.
    pub fn install_formulae<F: Fn(Progress)>(&self, progress_cb: F) -> Result<()> {
        let total = self.formulae.len();
        for (i, formula) in self.formulae.iter().enumerate() {
            cmd!(self.sh, "brew install {formula}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }

    /// Runs `brew install --cask` on every cask in its `casks` field.
    ///
    /// # Errors
    /// This function returns an error if `brew install --cask` is unsuccessful.
    pub fn install_casks<F: Fn(Progress)>(&self, progress_cb: F) -> Result<()> {
        let total = self.casks.len();
        for (i, cask) in self.casks.iter().enumerate() {
            cmd!(self.sh, "brew install --cask {cask}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }
}
