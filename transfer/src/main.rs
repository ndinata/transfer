mod cli;
mod config;
mod dir;

use std::process;

use anyhow::Result;

/// The program's help message, displayed when invoking the `-h` or `--help` flag.
const HELP: &str = "\
Transfer

USAGE:
  transfer [OPTIONS]

FLAGS:
  -h, --help            Prints help information

OPTIONS:
  --config-file=PATH    Uses the config file defined at PATH [default: 'config/config.toml']
  --brewfile=PATH       Uses the Brewfile defined at PATH [default: 'config/Brewfile']
";

/// Command-line arguments that the program supports.
struct AppArgs {
    /// Custom path to the config file.
    config_file: String,

    /// Custom path to the Brewfile.
    brewfile: String,
}

/// Default path to the config file.
const CONFIG_FILE_PATH: &str = "config/config.toml";

/// Default path to the Brewfile.
const BREWFILE_PATH: &str = "config/Brewfile";

fn main() -> Result<()> {
    let args = match parse_args() {
        Ok(a) => a,
        Err(e) => {
            eprintln!("InvalidArgsError: {e}");
            process::exit(1);
        }
    };

    println!("Hello, world!");

    if let Err(e) = cli::check_xcode_tools() {
        eprintln!("XcodeToolsError: {e}");
        process::exit(1);
    }

    if let Err(e) = cli::check_fish_shell(BREWFILE_PATH) {
        eprintln!("CheckFishError: {e}");
        process::exit(1);
    }

    cli::run(&args.config_file, &args.brewfile)?;

    println!("Done!");
    Ok(())
}

/// Parses command-line arguments received by the program.
///
/// Exits with code 0 if the help flag is passed.
fn parse_args() -> Result<AppArgs> {
    let mut pargs = pico_args::Arguments::from_env();

    // The help flag has highest priority, so we process it separately.
    if pargs.contains(["-h", "--help"]) {
        print!("{}", HELP);
        std::process::exit(0);
    }

    let args = AppArgs {
        config_file: pargs
            .opt_value_from_str("--config-file")?
            .unwrap_or(CONFIG_FILE_PATH.to_string()),
        brewfile: pargs
            .opt_value_from_str("--brewfile")?
            .unwrap_or(BREWFILE_PATH.to_string()),
    };
    Ok(args)
}
