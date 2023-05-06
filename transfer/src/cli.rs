use std::path::Path;

use anyhow::{Context, Result};

use crate::config::{self, Config};

// TODO: show intro instruction to add `fish` to list of shells

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

fn setup_brew<P: AsRef<Path>>(brewfile_path: P) -> Result<()> {
    use crate::config::brew;

    brew::install_homebrew()?;
    brew::update_brew()?;
    brew::disable_brew_analytics()?;
    brew::install_bundle(brewfile_path)?;
    Ok(())
}

fn copy_files(config: &Config) {
    for copyable in config.copy.iter() {
        if let Err(e) = copyable.copy() {
            eprintln!("CopyError('{}'): {e}", copyable.from);
        }
    }
}

fn download_files(config: &mut Config) {
    for downloadable in config.download.iter_mut() {
        if let Err(e) = downloadable.download_to_file(|_| ()) {
            eprintln!("DownloadError('{}'): {e}", downloadable.url);
        };
    }
}

fn run_scripts(config: &Config) {
    for runnable in config.run.iter() {
        if let Err(e) = runnable.run_script() {
            eprintln!("RunScriptError('{}'): {e}", runnable.script_path);
        }
    }
}

// fn get_timed_spinner() -> ProgressBar {
//     let spinner = ProgressBar::new_spinner();
//     spinner.enable_steady_tick(Duration::from_millis(120));
//     spinner.set_style(
//         ProgressStyle::with_template("{spinner:.blue} {msg} ({elapsed})")
//             .unwrap()
//             .tick_strings(&["▹▹▹▹▹", "▸▹▹▹▹", "▹▸▹▹▹", "▹▹▸▹▹", "▹▹▹▸▹", "▹▹▹▹▸"]),
//     );
//     spinner
// }
