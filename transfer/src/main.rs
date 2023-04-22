use std::process;
use transfer_lib::{self, Downloader};

#[tokio::main]
async fn main() {
    println!("Hello, world!");

    const CONFIG_FILE_PATH: &str = "config/config.toml";

    let config = match transfer_config::parse_config(CONFIG_FILE_PATH) {
        Ok(c) => c,
        Err(e) => {
            println!("ConfigError('{CONFIG_FILE_PATH}'): {e}");
            process::exit(1);
        }
    };

    for to_copy in config.copy {
        if let Err(e) = transfer_lib::copy_file(&to_copy.from, &to_copy.to) {
            println!(
                "CopyFileError('{0}' -> '{1}'): {e}",
                to_copy.from, to_copy.to
            );
        }
    }

    let downloader = Downloader::new();
    for to_download in config.download {
        let log_download_progress = |(downloaded, total_size)| match total_size {
            Some(total) => {
                let percentage = downloaded * 100 / total;
                println!("Downloaded {}% ({}/{}B)", percentage, downloaded, total);
            }
            None => {
                println!("Downloaded {}B", downloaded);
            }
        };

        if to_download.to.is_some() {
            if let Err(e) = downloader
                .download(
                    &to_download.from,
                    &to_download.to.unwrap(),
                    log_download_progress,
                )
                .await
            {
                println!("DownloadError('{0}'): {e}", to_download.from);
            }
        } else if to_download.run.is_some() {
            if let Err(e) = downloader
                .download_and_source(&to_download.from, log_download_progress)
                .await
            {
                println!("DownloadError('{0}'): {e}", to_download.from);
            }
        }
    }

    for to_run in config.run {
        if let Err(e) = transfer_lib::run_script(
            &to_run.command,
            vec![&to_run.script_path],
            &to_run.script_path,
        ) {
            println!("RunScriptError('{0}'): {e}", to_run.script_path);
        }
    }

    println!("Don't forget to also do these things!");
    for (i, to_remind) in config.reminders.iter().enumerate() {
        println!("{}. {}", i + 1, to_remind.instruction);
        println!("{}", to_remind.command);
        println!();
    }

    println!("Done!");
}
