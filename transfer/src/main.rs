use std::process;

mod cli;
mod xcode;

fn main() {
    println!("Hello, world!");

    if xcode::require_xcode_tools() {
        xcode::show_xcode_instructions();
        process::exit(0);
    }

    const CONFIG_FILE_PATH: &str = "config/config.toml";

    cli::run(CONFIG_FILE_PATH);

    println!("Done!");
}
