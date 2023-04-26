use serde::Deserialize;
use xshell::{cmd, Shell};

type Result<T, E = BrewError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum BrewError {
    #[error(transparent)]
    ShellError(#[from] xshell::Error),
}

#[derive(Debug, Deserialize)]
pub struct Brew {
    #[serde(skip, default = "init_shell")]
    sh: Shell,

    pub taps: Vec<String>,
    pub formulae: Vec<String>,
    pub casks: Vec<String>,
}

fn init_shell() -> Shell {
    Shell::new().expect("current dir should be able to be accessed")
}

pub enum BrewItem {
    Taps,
    Formulae,
    Casks,
}

type Progress = (usize, usize);

impl Brew {
    pub fn install_self(&self) -> Result<()> {
        const BREW_INSTALL_COMMAND: &str = "NONINTERACTIVE=1 /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"";
        cmd!(self.sh, "{BREW_INSTALL_COMMAND}").quiet().run()?;

        const BREW_UPDATE: &str = "brew update && brew upgrade";
        cmd!(self.sh, "{BREW_UPDATE}").quiet().run()?;

        const BREW_ANALYTICS_OFF: &str = "brew analytics off";
        cmd!(self.sh, "{BREW_ANALYTICS_OFF}").quiet().run()?;

        Ok(())
    }

    pub fn install_all<F: Fn(BrewItem, Progress)>(&self, progress_cb: F) -> Result<()> {
        self.install_taps(|prog| progress_cb(BrewItem::Taps, prog))
            .and_then(|_| self.install_formulae(|prog| progress_cb(BrewItem::Formulae, prog)))
            .and_then(|_| self.install_casks(|prog| progress_cb(BrewItem::Casks, prog)))
    }

    pub fn install_taps<F: Fn(Progress)>(&self, progress_cb: F) -> Result<()> {
        let total = self.taps.len();
        for (i, tap) in self.taps.iter().enumerate() {
            cmd!(self.sh, "brew tap {tap}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }

    pub fn install_formulae<F: Fn(Progress)>(&self, progress_cb: F) -> Result<()> {
        let total = self.formulae.len();
        for (i, formula) in self.formulae.iter().enumerate() {
            cmd!(self.sh, "brew install {formula}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }

    pub fn install_casks<F: Fn(Progress)>(&self, progress_cb: F) -> Result<()> {
        let total = self.casks.len();
        for (i, cask) in self.casks.iter().enumerate() {
            cmd!(self.sh, "brew install --cask {cask}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }
}
