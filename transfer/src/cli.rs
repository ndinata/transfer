use std::process;
use std::time::Duration;

use indicatif::{ProgressBar, ProgressStyle};

use transfer_config::Config;

pub fn run(config_file_path: &str) {
    eprintln!("Parsing config file at `{}`...", config_file_path);
    let mut config = match transfer_config::parse_config(config_file_path) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("ConfigError('{config_file_path}'): {e}, exiting.");
            process::exit(1);
        }
    };
    eprintln!("Config file parsed successfully.");
    eprintln!();

    handle_brew(&config);
    eprintln!();

    handle_copies(&config);
    eprintln!();

    handle_downloads(&mut config);
    eprintln!();

    handle_scripts(&config);
    eprintln!();

    println!("Don't forget to also do these things!");
    for (i, remindable) in config.reminders.iter().enumerate() {
        remindable.display_reminder(i + 1);
        println!();
    }
}

fn handle_brew(config: &Config) {
    let spinner = get_timed_spinner();

    let brew = &config.brew;
    spinner.set_message("Installing Homebrew...");
    if let Err(e) = brew.install_self() {
        spinner.abandon_with_message(format!("BrewError: {e}, exiting."));
        process::exit(1);
    };
    spinner.finish_with_message("Done installing Homebrew.");
    eprintln!();

    let progress_cb = |(curr, total)| {
        eprintln!("{}/{}", curr, total);
    };

    let spinner = get_timed_spinner();
    spinner.set_message("Installing Brew taps...");
    if let Err(e) = brew.install_taps(progress_cb) {
        spinner.abandon_with_message(format!("BrewError: {e}, exiting."));
        process::exit(1);
    }
    spinner.finish_with_message("Done installing Brew taps.");

    let spinner = get_timed_spinner();
    spinner.set_message("Installing Brew formulae...");
    if let Err(e) = brew.install_formulae(progress_cb) {
        spinner.abandon_with_message(format!("BrewError: {e}, exiting."));
        process::exit(1);
    }
    spinner.finish_with_message("Done installing Brew formulae.");

    let spinner = get_timed_spinner();
    spinner.set_message("Installing Brew casks...");
    if let Err(e) = brew.install_casks(progress_cb) {
        spinner.abandon_with_message(format!("BrewError: {e}, exiting."));
        process::exit(1);
    }
    spinner.finish_with_message("Done installing Brew casks.");
}

fn handle_copies(config: &Config) {
    eprintln!("Copying files...");
    for copyable in config.copy.iter() {
        if let Err(e) = copyable.copy() {
            eprintln!(
                "CopyFileError('{0}' -> '{1}'): {e}",
                copyable.from, copyable.to
            );
        }
    }
    eprintln!("Done copying files.");
}

fn handle_downloads(config: &mut Config) {
    eprintln!("Starting file downloads...");
    for downloadable in config.download.iter_mut() {
        if let Err(e) = downloadable.download(|(downloaded, total)| {
            let percentage = downloaded * 100 / total;
            eprintln!("Downloaded {}% ({}/{}B)", percentage, downloaded, total);
        }) {
            eprintln!("DownloadError('{0}'): {e}", downloadable.from);
        }
    }
    eprintln!("Done downloading files.");
}

fn handle_scripts(config: &Config) {
    eprintln!("Running scripts...");
    for runnable in config.run.iter() {
        let s = get_timed_spinner();
        s.set_message(format!("{}...", runnable.title));

        if let Err(e) = runnable.run_script() {
            s.abandon_with_message(format!("RunScriptError('{0}'): {e}", runnable.script_path));
        } else {
            s.finish_with_message(format!("{} Done!", s.message()));
        }
    }
    eprintln!("Done running scripts.");
}

fn get_timed_spinner() -> ProgressBar {
    let spinner = ProgressBar::new_spinner();
    spinner.enable_steady_tick(Duration::from_millis(120));
    spinner.set_style(
        ProgressStyle::with_template("{spinner:.blue} {msg} ({elapsed})")
            .unwrap()
            .tick_strings(&["▹▹▹▹▹", "▸▹▹▹▹", "▹▸▹▹▹", "▹▹▸▹▹", "▹▹▹▸▹", "▹▹▹▹▸"]),
    );
    spinner
}
