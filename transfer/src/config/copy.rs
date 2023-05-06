use std::fs;
use std::path::Path;

use anyhow::{bail, ensure, Context, Result};
use serde::{de, Deserialize};

use crate::dir;

/// The configuration schema for copying files to the target machine.
#[derive(Debug, Deserialize, PartialEq)]
pub struct Copyable {
    pub from: String,

    #[serde(deserialize_with = "deserialise_dir")]
    pub to_dir: String,
}

/// Custom deserialiser for `to_dir` to enforce it ending with a '/' so it is
/// treated as a valid dir.
///
/// Reference:
/// https://users.rust-lang.org/t/need-help-with-serde-deserialize-with/18374/5
fn deserialise_dir<'de, D>(de: D) -> std::result::Result<String, D::Error>
where
    D: de::Deserializer<'de>,
{
    let s: String = String::deserialize(de)?;
    if !s.ends_with('/') {
        return Err(de::Error::custom(format!(
            "'{}' in your config file needs to end with a '/' as it is a dir",
            s
        )));
    }
    Ok(s)
}

impl Copyable {
    /// If `self.from` is a file, copies it to the path defined in `self.to_dir`.
    /// If `self.from` is instead a dir, copies every file in it to the path
    /// defined in `self.to_dir`.
    ///
    /// # Errors
    /// This function returns an error if `self.from` doesn't actually exist or
    /// is neither a valid file nor dir.
    ///
    /// It also propagates any errors returned from the copying process.
    pub fn copy(&self) -> Result<()> {
        let from = Path::new(&self.from);
        ensure!(from.exists(), "'{}' doesn't exist", self.from);

        if from.is_file() {
            self.copy_single_file(&self.from, &self.to_dir)
                .with_context(|| format!("cannot copy '{}' to '{}'", self.from, self.to_dir))?;
        } else if from.is_dir() {
            self.copy_dir_files(&self.from, &self.to_dir)
                .with_context(|| {
                    format!("cnanot copy files in '{}' to '{}'", self.from, self.to_dir)
                })?;
        } else {
            bail!("'{}' is an invalid path", self.from);
        }
        Ok(())
    }

    /// Copies the file to the target dir, creating the dir first if it doesn't
    /// exist yet.
    ///
    /// # Errors
    /// This function propagates any errors returned from creating the dir and
    /// copying the file.
    pub fn copy_single_file<P: AsRef<Path>>(&self, file_path: P, to_dir: P) -> Result<()> {
        let from_file = file_path.as_ref();
        debug_assert!(from_file.is_file());

        let filename = from_file.file_name().unwrap();
        let to_path = dir::create_dir(to_dir)?.join(filename);
        fs::copy(from_file, to_path)?;
        Ok(())
    }

    /// Copies all files in the source dir to the target dir, creating the target
    /// dir first if it doesn't exist yet.
    ///
    /// # Errors
    /// This function propagates any errors returned from creating the target dir,
    /// reading the source dir, and copying the files.
    pub fn copy_dir_files<P: AsRef<Path>>(&self, from_dir: P, to_dir: P) -> Result<()> {
        let from_dir = from_dir.as_ref();
        debug_assert!(from_dir.is_dir());

        let to_dir = dir::create_dir(to_dir)?;

        for entry in from_dir.read_dir()? {
            let path = entry?.path();
            if path.is_dir() {
                continue;
            }

            if let Some(filename) = path.file_name() {
                let to_path = to_dir.join(filename);
                fs::copy(path, to_path)?;
            }
        }
        Ok(())
    }
}
