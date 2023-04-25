use xshell::{cmd, Shell};

type Result<T, E = BrewError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum BrewError {
    #[error(transparent)]
    ShellError(#[from] xshell::Error),
}

pub struct Brew {
    sh: Shell,
}

impl Brew {
    pub fn init() -> Result<Brew> {
        Ok(Brew { sh: Shell::new()? })
    }

    pub fn install_self(&self) -> Result<()> {
        const BREW_INSTALL_COMMAND: &str = "NONINTERACTIVE=1 /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"";
        cmd!(self.sh, "{BREW_INSTALL_COMMAND}").quiet().run()?;

        const BREW_UPDATE: &str = "brew update && brew upgrade";
        cmd!(self.sh, "{BREW_UPDATE}").quiet().run()?;

        const BREW_ANALYTICS_OFF: &str = "brew analytics off";
        cmd!(self.sh, "{BREW_ANALYTICS_OFF}").quiet().run()?;

        Ok(())
    }

    pub fn install_taps<F: Fn(Progress)>(&self, taps: Vec<String>, progress_cb: F) -> Result<()> {
        let total = taps.len();
        for (i, tap) in taps.iter().enumerate() {
            cmd!(self.sh, "brew tap {tap}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }

    pub fn install_formulae<F: Fn(Progress)>(
        &self,
        formulae: Vec<String>,
        progress_cb: F,
    ) -> Result<()> {
        let total = formulae.len();
        for (i, formula) in formulae.iter().enumerate() {
            cmd!(self.sh, "brew install {formula}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }

    pub fn install_casks<F: Fn(Progress)>(&self, casks: Vec<String>, progress_cb: F) -> Result<()> {
        let total = casks.len();
        for (i, cask) in casks.iter().enumerate() {
            cmd!(self.sh, "brew install --cask {cask}").quiet().run()?;
            progress_cb((i + 1, total));
        }
        Ok(())
    }
}

type Progress = (usize, usize);
