mod brew;
mod config;
mod copy;
mod download;
mod remind;
mod run;

pub use self::brew::{Brew, BrewError};
pub use self::config::{parse_config, Config};
pub use self::copy::{CopyError, Copyable};
pub use self::download::{DownloadError, Downloadable};
pub use self::remind::Remindable;
pub use self::run::{RunError, Runnable};

use std::env::{self, VarError};

/// Replaces the `~` in `dir` with whatever value is associated with the `HOME` envvar.
///
/// Very naive implementation with the assumption that the provided argument is
/// a proper dir and that the `HOME` envvar points to your machine's home dir.
///
/// # Errors
/// Returns an error if the `HOME` envvar isn't set, isn't valid Unicode, or
/// contains the "=" character.
pub fn macos_replace_home_dir(dir: &str) -> Result<String, VarError> {
    let home_dir = env::var("HOME")?;
    Ok(dir.replace('~', &home_dir))
}
