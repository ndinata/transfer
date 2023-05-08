use std::fs;
use std::path::Path;
use std::process::Command;

use anyhow::{bail, Context, Result};

use crate::config::{self, Config};

/// Parses the specified config file, and reports progress to the CLI when
/// carrying out the operations in this order: set up Homebrew, copy local files,
/// download remote files, run scripts, and print out reminders.
///
/// # Errors
/// This function returns an error if parsing the config file failed, or if the
/// Homebrew setup process failed.
pub fn run<P: AsRef<Path>>(config_file_path: P, brewfile_path: P) -> Result<()> {
    let config_file_path = config_file_path.as_ref();

    eprintln!("Parsing config file at '{}'...", config_file_path.display());
    let mut config = config::parse_config(config_file_path)
        .with_context(|| format!("unable to parse config at '{}'", config_file_path.display()))?;

    eprintln!("Config file parsed successfully!\n");

    setup_brew(brewfile_path)?;

    copy_files(&config);

    download_files(&mut config);

    run_scripts(&config);

    display_reminders(&config);
    Ok(())
}

/// Checks if Xcode command-line tools have been installed.
///
/// # Errors
/// This function returns an error if `xcode-select -p` doesn't return 0 exit code,
/// which indicates the tools are not installed yet.
pub fn check_xcode_tools() -> Result<()> {
    let output = Command::new("xcode-select").arg("-p").output()?;
    if !output.status.success() {
        println!("It seems like you haven't installed Xcode's command-line tools.");
        println!("You can do so by running this command:");
        println!("  xcode-select --install");
        println!("Please try again after you've done this!");
        bail!("Xcode command-line tools not installed yet");
    }

    Ok(())
}

/// Checks if `fish` is in the list of acceptable shells if it is detected to be
/// part of the Brewfile bundle installation.
///
/// # Errors
/// This function returns an error if it fails to read the Brewfile specified by
/// the path, or if it fails to read `/etc/shells`, or if `fish` is included in
/// the Brewfile but it isn't yet included in the list of acceptable shells.
pub fn check_fish_shell<P: AsRef<Path>>(brewfile_path: P) -> Result<()> {
    let brewfile = fs::read_to_string(brewfile_path)?;
    let fish = brewfile.lines().find(|l| l.contains("brew \"fish\""));
    if fish.is_some() {
        let shells = fs::read_to_string("/etc/shells")?;
        let fish = shells.lines().find(|l| l.contains("fish"));
        if fish.is_none() {
            println!("Looks like you will be installing `fish` in your Brewfile.");
            println!("In that case, you need to do the following before running this program, as it tries to not request sudo permissions during runtime:");
            println!("  sudo bash -c \"echo /opt/homebrew/bin/fish >> /etc/shells\"");
            println!(
                "This is to prevent errors that might come up during any `fish`-related setup."
            );
            println!("Please try again after you've done this!");
            bail!("`fish` isn't in list of acceptable shells yet");
        }
    }
    Ok(())
}

/// Does the following Homebrew operations in sequence: installs Homebrew,
/// updates Homebrew, disables Homebrew analytics, and installs the Homebrew
/// bundle defined in `brewfile_path`.
///
/// # Errors
/// This function propagates any errors returned by any one of those operations.
fn setup_brew<P: AsRef<Path>>(brewfile_path: P) -> Result<()> {
    use crate::config::brew;

    eprintln!("Setting up Homebrew...");
    brew::install_homebrew().context("failed to install Homebrew")?;
    brew::update_brew().context("failed to update Homebrew")?;
    brew::disable_brew_analytics().context("failed to disable Homebrew analytics")?;
    brew::install_bundle(brewfile_path).context("failed to install Homebrew bundle")?;
    eprintln!("Homebrew setup successful!\n");
    Ok(())
}

/// Copies all files defined in the config file.
fn copy_files(config: &Config) {
    if config.copy.is_empty() {
        eprintln!("No files to copy, skipping.\n");
        return;
    }

    eprintln!("Copying files...");
    for copyable in config.copy.iter() {
        if let Err(e) = copyable.copy() {
            eprintln!("CopyError('{}'): {e}", copyable.from);
        }
    }
    eprintln!("Done copying files.\n");
}

/// Downloads and stores all files defined in the config file.
fn download_files(config: &mut Config) {
    if config.download.is_empty() {
        eprintln!("No files to download, skipping.\n");
        return;
    }

    eprintln!("Starting file downloads...");
    for downloadable in config.download.iter_mut() {
        if let Err(e) = downloadable.download_to_file(|_| ()) {
            eprintln!("DownloadError('{}'): {e}", downloadable.url);
        };
    }
    eprintln!("Done downloading files.\n");
}

/// Runs all scripts defined in the config file.
fn run_scripts(config: &Config) {
    if config.run.is_empty() {
        eprintln!("No scripts to run, skipping.\n");
        return;
    }

    eprintln!("Running scripts...");
    for runnable in config.run.iter() {
        if let Err(e) = runnable.run_script() {
            eprintln!("RunScriptError('{}'): {e}", runnable.script_path);
        }
    }
    eprintln!("Done running scripts.\n");
}

/// Displays all reminders defined in the config file.
fn display_reminders(config: &Config) {
    if config.reminders.is_empty() {
        return;
    }

    println!("Don't forget to also do these things!");
    for (i, remindable) in config.reminders.iter().enumerate() {
        remindable.display_reminder(i + 1);
    }
}
