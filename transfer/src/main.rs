use std::process;
use transfer_lib::{self, Brew, Downloader};

fn main() {
    println!("Hello, world!");

    const CONFIG_FILE_PATH: &str = "config/config.toml";

    eprintln!("Parsing config file at `{}`...", CONFIG_FILE_PATH);
    let config = match transfer_config::parse_config(CONFIG_FILE_PATH) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("ConfigError('{CONFIG_FILE_PATH}'): {e}, exiting.");
            process::exit(1);
        }
    };
    eprintln!("Config file parsed successfully.");
    eprintln!();

    eprintln!("Installing Homebrew...");
    let brew = match Brew::init().and_then(|brew| {
        brew.install_self()?;
        Ok(brew)
    }) {
        Ok(brew) => brew,
        Err(e) => {
            eprintln!("BrewError: {e}, exiting.");
            process::exit(1);
        }
    };
    eprintln!("Done installing Homebrew.");
    eprintln!();

    let brew_install_progress_cb = |(curr, total)| {
        eprintln!("{}/{}", curr, total);
    };

    eprintln!("Installing Brew taps...");
    if let Err(e) = brew
        .install_taps(config.brew.taps, brew_install_progress_cb)
        .and_then(|_| {
            eprintln!("Installing Brew formulae...");
            brew.install_formulae(config.brew.formulae, brew_install_progress_cb)
        })
        .and_then(|_| {
            eprintln!("Installing Brew casks...");
            brew.install_casks(config.brew.casks, brew_install_progress_cb)
        })
    {
        eprintln!("BrewError: {e}, exiting.");
        process::exit(1);
    }

    eprintln!();
    eprintln!("Copying files...");
    for to_copy in config.copy {
        if let Err(e) = transfer_lib::copy_file(&to_copy.from, &to_copy.to) {
            eprintln!(
                "CopyFileError('{0}' -> '{1}'): {e}",
                to_copy.from, to_copy.to
            );
        }
    }
    eprintln!("Done copying files.");
    eprintln!();

    let downloader = Downloader::init();
    if let Err(e) = downloader {
        eprintln!("DownloaderError: {e}, skipping all downloads.",);
    } else {
        eprintln!("Starting file downloads...");
        let mut downloader = downloader.unwrap();
        for to_download in config.download {
            let log_download_progress = |(downloaded, total)| {
                let percentage = downloaded * 100 / total;
                eprintln!("Downloaded {}% ({}/{}B)", percentage, downloaded, total);
            };

            if to_download.to.is_some() {
                if let Err(e) = downloader.download(
                    &to_download.from,
                    &to_download.to.unwrap(),
                    log_download_progress,
                ) {
                    eprintln!("DownloadError('{0}'): {e}", to_download.from);
                }
            } else if to_download.run.is_some() {
                if let Err(e) =
                    downloader.download_and_source(&to_download.from, log_download_progress)
                {
                    eprintln!("DownloadError('{0}'): {e}", to_download.from);
                }
            }
        }
        eprintln!("Done downloading files.");
    }
    eprintln!();

    eprintln!("Running scripts...");
    for to_run in config.run {
        eprintln!("{}...", to_run.title);
        if let Err(e) = transfer_lib::run_script(
            &to_run.command,
            vec![&to_run.script_path],
            &to_run.script_path,
        ) {
            eprintln!("RunScriptError('{0}'): {e}", to_run.script_path);
        }
    }
    eprintln!("Done running scripts.");
    eprintln!();

    println!("Don't forget to also do these things!");
    for (i, to_remind) in config.reminders.iter().enumerate() {
        println!("{}. {}", i + 1, to_remind.instruction);
        println!("$ {}", to_remind.command);
        println!();
    }

    println!("Done!");
}
