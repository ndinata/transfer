use std::process::Command;

type Result<T, E = BrewError> = std::result::Result<T, E>;

#[derive(thiserror::Error, Debug)]
pub enum BrewError {
    // TODO
}

pub struct Brew {
    bash: Command,
}

impl Default for Brew {
    fn default() -> Self {
        Self::new()
    }
}

impl Brew {
    pub fn new() -> Brew {
        Brew {
            bash: Command::new("bash"),
        }
    }

    pub fn install_self(&self) -> Result<()> {
        let BREW_INSTALL_COMMAND: &str = "NONINTERACTIVE=1 /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"";

        let bu = "brew update && brew upgrade";
        let ao = "brew analytics off";

        Ok(())
    }

    pub fn install_formulae(&self) -> Result<()> {
        Ok(())
    }
}
