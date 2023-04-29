use std::process;

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
    eprintln!("Installing Homebrew...");
    let brew = &config.brew;
    if let Err(e) = brew.install_self() {
        eprintln!("BrewError: {e}, exiting.");
        process::exit(1);
    };
    eprintln!("Done installing Homebrew.");
    eprintln!();

    let brew_install_progress_cb = |(curr, total)| {
        eprintln!("{}/{}", curr, total);
    };

    eprintln!("Installing Brew taps...");
    if let Err(e) = brew
        .install_taps(brew_install_progress_cb)
        .and_then(|_| {
            eprintln!("Installing Brew formulae...");
            brew.install_formulae(brew_install_progress_cb)
        })
        .and_then(|_| {
            eprintln!("Installing Brew casks...");
            brew.install_casks(brew_install_progress_cb)
        })
    {
        eprintln!("BrewError: {e}, exiting.");
        process::exit(1);
    }
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
        eprintln!("{}...", runnable.title);
        if let Err(e) = runnable.run_script() {
            eprintln!("RunScriptError('{0}'): {e}", runnable.script_path);
        }
    }
    eprintln!("Done running scripts.");
}
