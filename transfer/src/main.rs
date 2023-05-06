mod cli;
mod config;
mod dir;
mod xcode;

use std::process;

use anyhow::Result;

fn main() -> Result<()> {
    println!("Hello, world!");

    if xcode::require_xcode_tools() {
        xcode::show_xcode_instructions();
        process::exit(0);
    }

    const CONFIG_FILE_PATH: &str = "config/config.toml";
    const BREWFILE_PATH: &str = "config/Brewfile";

    cli::run(CONFIG_FILE_PATH, BREWFILE_PATH)?;

    println!("Done!");
    Ok(())
}
