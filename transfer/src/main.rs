mod cli;
mod config;
mod dir;

use std::process;

use anyhow::Result;

fn main() -> Result<()> {
    println!("Hello, world!");

    if let Err(e) = cli::check_xcode_tools() {
        eprintln!("XcodeToolsError: {e}");
        process::exit(1);
    }

    const CONFIG_FILE_PATH: &str = "config/config.toml";
    const BREWFILE_PATH: &str = "config/Brewfile";

    if let Err(e) = cli::check_fish_shell(BREWFILE_PATH) {
        eprintln!("CheckFishError: {e}");
        process::exit(1);
    }

    cli::run(CONFIG_FILE_PATH, BREWFILE_PATH)?;

    println!("Done!");
    Ok(())
}
