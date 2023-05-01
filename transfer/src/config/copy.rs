use std::fs;
use std::path::Path;

use anyhow::anyhow;
use serde::Deserialize;

type Result<T, E = anyhow::Error> = std::result::Result<T, E>;

/// The configuration schema for copying files to the target machine.
#[derive(Debug, Deserialize, PartialEq)]
pub struct Copyable {
    pub from: String,
    pub to_dir: String,
}

impl Copyable {
    /// If `self.from` is a file, copies it to the path defined in `self.to`.
    /// If `self.from` is instead a dir, copies every file in it to the path
    /// defined in `self.to`.
    ///
    /// # Errors
    /// This function returns an error if `self.from` doesn't actually exist or
    /// is neither a valid file nor dir.
    ///
    /// It also propagates any errors returned from the copying process.
    pub fn copy(&self) -> Result<()> {
        let from = Path::new(&self.from);
        if !from.exists() {
            return Err(anyhow!(format!("{} doesn't exist", self.from)));
        }

        if from.is_file() {
            self.copy_single_file(&self.from, &self.to_dir)?;
        } else if from.is_dir() {
            self.copy_dir_files(&self.from, &self.to_dir)?;
        } else {
            return Err(anyhow!(format!("{} is an invalid path", self.from)));
        }
        Ok(())
    }

    /// Copies the file to the target dir, creating the dir first if it doesn't
    /// exist yet.
    ///
    /// # Errors
    /// This function propagates any errors returned from creating the dir and
    /// copying the file.
    pub fn copy_single_file<P: AsRef<Path>>(&self, file_path: &P, to_dir: &P) -> Result<()> {
        let from_file = file_path.as_ref();
        debug_assert!(from_file.is_file());

        let filename = from_file.file_name().unwrap();
        let to_path = crate::dir::create_dir(to_dir)?.join(filename);
        fs::copy(from_file, to_path)?;
        Ok(())
    }

    /// Copies all files from the source dir to the target dir, creating the target
    /// dir first if it doesn't exist yet.
    ///
    /// # Errors
    /// This function propagates any errors returned from creating the target dir,
    /// reading the source dir, and copying the files.
    pub fn copy_dir_files<P: AsRef<Path>>(&self, from_dir: &P, to_dir: &P) -> Result<()> {
        let from_dir = from_dir.as_ref();
        debug_assert!(from_dir.is_dir());

        let to_dir = crate::dir::create_dir(to_dir)?;

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
