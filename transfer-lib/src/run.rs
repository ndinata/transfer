use std::error::Error;
use std::path::Path;
use std::process::Command;

type AnyError = Box<dyn Error>;

pub fn run_script(command: &str, args: Vec<&str>, script_path: &str) -> Result<(), AnyError> {
    if !Path::new(script_path).is_file() {
        return Err("Invalid script path".into());
    }

    let status = Command::new(command).args(args).spawn().unwrap().wait()?;

    if !status.success() {
        return Err("source failed".into());
    }

    Ok(())
}
