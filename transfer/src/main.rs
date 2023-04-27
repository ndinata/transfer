use std::process;

fn main() {
    println!("Hello, world!");

    const CONFIG_FILE_PATH: &str = "config/config.toml";

    eprintln!("Parsing config file at `{}`...", CONFIG_FILE_PATH);
    let config = match transfer_lib::parse_config(CONFIG_FILE_PATH) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("ConfigError('{CONFIG_FILE_PATH}'): {e}, exiting.");
            process::exit(1);
        }
    };
    eprintln!("Config file parsed successfully.");
    eprintln!();

    eprintln!("Installing Homebrew...");
    let brew = config.brew;
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

    eprintln!();
    eprintln!("Copying files...");
    for copyable in config.copy {
        if let Err(e) = copyable.copy() {
            eprintln!(
                "CopyFileError('{0}' -> '{1}'): {e}",
                copyable.from, copyable.to
            );
        }
    }
    eprintln!("Done copying files.");
    eprintln!();

    eprintln!("Starting file downloads...");
    for mut downloadable in config.download {
        if let Err(e) = downloadable.download(|(downloaded, total)| {
            let percentage = downloaded * 100 / total;
            eprintln!("Downloaded {}% ({}/{}B)", percentage, downloaded, total);
        }) {
            eprintln!("DownloadError('{0}'): {e}", downloadable.from);
        }
    }
    eprintln!("Done downloading files.");
    eprintln!();

    eprintln!("Running scripts...");
    for runnable in config.run {
        eprintln!("{}...", runnable.title);
        if let Err(e) = runnable.run_script() {
            eprintln!("RunScriptError('{0}'): {e}", runnable.script_path);
        }
    }
    eprintln!("Done running scripts.");
    eprintln!();

    println!("Don't forget to also do these things!");
    for (i, remindable) in config.reminders.iter().enumerate() {
        remindable.display_reminder(i + 1);
        println!();
    }

    println!("Done!");
}
