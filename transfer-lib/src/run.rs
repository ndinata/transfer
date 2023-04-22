use std::path::Path;
use std::process::Command;

#[derive(thiserror::Error, Debug)]
pub enum RunError {
    #[error("`{0}` is an invalid file path")]
    InvalidFile(String),

    #[error("`{0}` failed to run successfully")]
    FailedRun(String),

    #[error(transparent)]
    IoError(#[from] std::io::Error),
}

pub fn run_script(command: &str, args: Vec<&str>, script_path: &str) -> Result<(), RunError> {
    if !Path::new(script_path).is_file() {
        return Err(RunError::InvalidFile(script_path.to_string()));
    }

    let status = Command::new(command)
        .args(args)
        .spawn()
        .or(Err(RunError::FailedRun(command.to_string())))?
        .wait()?;
    if !status.success() {
        return Err(RunError::FailedRun(command.to_string()));
    }
    Ok(())
}
