use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{anyhow, Result};
use simple_home_dir::expand_tilde;

/// Creates the dir if it doesn't exist yet, together with all its parent components.
///
/// # Errors
/// This function may return an error if the $HOME envvar isn't set to a valid value.
///
/// This function also returns an error if creating the dir (and its parents) fails.
pub fn create_dir<P: AsRef<Path>>(dir: P) -> Result<PathBuf> {
    let dir = expand_tilde(dir).ok_or_else(|| anyhow!("$HOME is not set or invalid"))?;
    if !dir.exists() {
        fs::create_dir_all(&dir)?;
    }
    Ok(dir)
}
