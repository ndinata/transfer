use std::fs;
use std::path::Path;

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

    eprintln!("Setting up Homebrew...");
    setup_brew(brewfile_path).context("Homebrew setup failed")?;
    eprintln!("Homebrew setup successful!\n");

    eprintln!("Copying files...");
    copy_files(&config);
    eprintln!("Done copying files.\n");

    eprintln!("Starting file downloads...");
    download_files(&mut config);
    eprintln!("Done downloading files.\n");

    eprintln!("Running scripts...");
    run_scripts(&config);
    eprintln!("Done running scripts.\n");

    println!("Don't forget to also do these things!");
    for (i, remindable) in config.reminders.iter().enumerate() {
        remindable.display_reminder(i + 1);
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

    brew::install_homebrew()?;
    brew::update_brew()?;
    brew::disable_brew_analytics()?;
    brew::install_bundle(brewfile_path)?;
    Ok(())
}

/// Copies all files defined in the config file.
fn copy_files(config: &Config) {
    for copyable in config.copy.iter() {
        if let Err(e) = copyable.copy() {
            eprintln!("CopyError('{}'): {e}", copyable.from);
        }
    }
}

/// Downloads and stores all files defined in the config file.
fn download_files(config: &mut Config) {
    for downloadable in config.download.iter_mut() {
        if let Err(e) = downloadable.download_to_file(|_| ()) {
            eprintln!("DownloadError('{}'): {e}", downloadable.url);
        };
    }
}

/// Runs all scripts defined in the config file.
fn run_scripts(config: &Config) {
    for runnable in config.run.iter() {
        if let Err(e) = runnable.run_script() {
            eprintln!("RunScriptError('{}'): {e}", runnable.script_path);
        }
    }
}
