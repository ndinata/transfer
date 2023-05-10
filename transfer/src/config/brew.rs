use std::path::Path;
use std::process::Command;

use anyhow::{ensure, Result};

/// Downloads the Homebrew installer script and runs it, if it doesn't exist yet.
///
/// If installation is successful, load Homebrew's `bin` dir into `$PATH` for this
/// shell session.
///
/// # Errors
/// This function returns an error if the download or installation failed, or
/// if loading the dir failed.
pub fn install_homebrew() -> Result<()> {
    let output = Command::new("brew").arg("--version").output()?;
    if output.status.success() {
        return Ok(());
    }

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

/// Runs `brew update` and `brew upgrade` in sequence.
///
/// # Errors
/// This function returns an error if either of those two commands failed to
/// terminate successfully.
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

/// Disables Homebrew analytics by running `brew analytics off`.
///
/// # Errors
/// This function returns an error if the command didn't terminate successfully.
pub fn disable_brew_analytics() -> Result<()> {
    let output = Command::new("brew").arg("analytics").arg("off").output()?;
    ensure!(
        output.status.success(),
        "`brew analytics off` failed to terminate successfully"
    );
    Ok(())
}

/// Runs `brew bundle` using the Brewfile specified by `brewfile_path`.
///
/// # Errors
/// This function returns an error if the path is invalid or if the command itself
/// returns an error.
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
