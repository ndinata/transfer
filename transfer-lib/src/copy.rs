use std::error::Error;
use std::fs;
use std::path::Path;

type AnyError = Box<dyn Error>;

pub fn copy_file(from: &str, to: &str) -> Result<(), AnyError> {
    if Path::new(from).is_file() {
        copy_single_file(from, to)?;
    } else {
        copy_dir_files(from, to)?;
    }
    Ok(())
}

fn copy_single_file(file_path: &str, to_dir: &str) -> Result<(), AnyError> {
    let mut to_dir = create_dir(to_dir)?;
    let filename = Path::new(file_path).file_name().unwrap().to_str().unwrap();

    to_dir.push_str(filename);

    fs::copy(file_path, to_dir)?;
    Ok(())
}

fn copy_dir_files(from_dir: &str, to_dir: &str) -> Result<(), AnyError> {
    let to_dir = create_dir(to_dir)?;
    for entry in Path::new(from_dir).read_dir()? {
        let path = entry?.path();
        if path.is_dir() {
            continue;
        }
        let filename = path.file_name().unwrap().to_str().unwrap();

        let to_dir = format!("{}{}", to_dir, filename);
        fs::copy(path, to_dir)?;
    }

    Ok(())
}

fn macos_replace_home_dir(dir: &str) -> Result<String, AnyError> {
    let home_dir = std::env::var("HOME")?;
    Ok(dir.replace('~', &home_dir))
}

fn create_dir(dir: &str) -> Result<String, AnyError> {
    let dir = macos_replace_home_dir(dir)?;
    if !Path::new(&dir).exists() {
        std::fs::create_dir_all(&dir)?;
    }
    Ok(dir)
}
