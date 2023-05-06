mod cli;
mod config;
mod dir;
mod xcode;

use std::process;

use anyhow::Result;

fn main() -> Result<()> {
    println!("Hello, world!");

    if !xcode::has_xcode_tools() {
        xcode::show_xcode_instructions();
        process::exit(0);
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
