use std::path::Path;

use anyhow::{Context, Result};

use crate::config::{self, Config};

// TODO: show intro instruction to add `fish` to list of shells

pub fn run<P: AsRef<Path>>(config_file_path: P, brewfile_path: P) -> Result<()> {
    let config_file_path = config_file_path.as_ref();
    eprintln!("Parsing config file at `{}`...", config_file_path.display());

    let mut config = config::parse_config(config_file_path)
        .with_context(|| format!("unable to parse config at '{}'", config_file_path.display()))?;

    eprintln!("Config file parsed successfully.\n");

    setup_brew(brewfile_path)?;
    eprintln!();

    copy_files(&config)?;
    eprintln!();

    download_files(&mut config);
    eprintln!();

    run_scripts(&config);
    eprintln!();

    println!("Don't forget to also do these things!");
    for (i, remindable) in config.reminders.iter().enumerate() {
        remindable.display_reminder(i + 1);
        println!();
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

fn copy_files(config: &Config) -> Result<()> {
    eprintln!("Copying files...");
    for copyable in config.copy.iter() {
        if let Err(e) = copyable.copy() {
            eprintln!("CopyError('{}'): {e}", copyable.from);
        }
    }
    eprintln!("Done copying files.");
    Ok(())
}

fn download_files(config: &mut Config) {
    eprintln!("Starting file downloads...");
    for downloadable in config.download.iter_mut() {
        if let Err(e) = downloadable.download_to_file(|_| ()) {
            eprintln!("DownloadError('{}'): {e}", downloadable.url);
        };

        // let s = get_timed_spinner();
        // let dl_filename = &downloadable.to_path;

        // let progress_cb = |(downloaded, total)| {
        //     let percentage = downloaded * 100 / total;
        //     s.set_message(format!(
        //         "Downloading {}: {}% ({}/{}B)",
        //         dl_filename, percentage, downloaded, total
        //     ));
        // };

        // if let Err(e) = downloadable.download_to_file(progress_cb) {
        //     s.abandon_with_message(format!("DownloadError('{}'): {e}", downloadable.url));
        // } else {
        //     s.finish_with_message(format!("{}, done!", s.message()));
        // }
    }
    eprintln!("Done downloading files.");
}

fn run_scripts(config: &Config) {
    eprintln!("Running scripts...");
    for runnable in config.run.iter() {
        // let s = get_timed_spinner();
        // s.set_message(format!("{}...", runnable.title));

        if let Err(e) = runnable.run_script() {
            eprintln!("RunScriptError('{}'): {e}", runnable.script_path);
        }

        // if let Err(e) = runnable.run_script() {
        //     s.abandon_with_message(format!("RunScriptError('{0}'): {e}", runnable.script_path));
        // } else {
        //     s.finish_with_message(format!("{} Done!", s.message()));
        // }
    }
    eprintln!("Done running scripts.");
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
