use std::path::Path;
use std::process::Command;

use anyhow::{ensure, Result};

pub fn install_homebrew() -> Result<()> {
    const HOMEBREW_INSTALL_URL: &str =
        "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh";

    let output = Command::new("bash")
        .arg("-c")
        .arg(format!("$(curl -fsSL {})", HOMEBREW_INSTALL_URL))
        .env("NONINTERACTIVE", "1")
        .output()?;
    ensure!(
        output.status.success(),
        "something went wrong when downloading and installing Homebrew"
    );

    let output = Command::new("eval")
        .arg("$(/opt/homebrew/bin/brew shellenv)")
        .output()?;
    ensure!(
        output.status.success(),
        "unable to expose Homebrew bin directory"
    );

    Ok(())
}

pub fn update_brew() -> Result<()> {
    let mut brew = Command::new("brew");

    let output = brew.arg("update").output()?;
    ensure!(
        output.status.success(),
        "`brew update` failed to terminate successfully"
    );
    let output = brew.arg("upgrade").output()?;
    ensure!(
        output.status.success(),
        "`brew upgrade` failed to terminate successfully"
    );
    Ok(())
}

pub fn disable_brew_analytics() -> Result<()> {
    let output = Command::new("brew").arg("analytics").arg("off").output()?;
    ensure!(
        output.status.success(),
        "`brew analytics off` failed to terminate successfully"
    );
    Ok(())
}

pub fn install_bundle<P: AsRef<Path>>(brewfile_path: P) -> Result<()> {
    let brewfile_path_str = brewfile_path.as_ref().to_str();
    ensure!(
        brewfile_path_str.is_some(),
        "cannot find valid Brewfile at '{}'",
        brewfile_path.as_ref().display()
    );

    let output = Command::new("brew")
        .arg("bundle")
        .env("HOMEBREW_BUNDLE_FILE", brewfile_path_str.unwrap())
        .output()?;

    ensure!(
        output.status.success(),
        "`brew bundle` failed to terminate successfully"
    );
    Ok(())
}
