use std::cmp;
use std::error::Error;
use std::fs::{self, File};
use std::io::Write;
use std::process::Command;

use futures_util::StreamExt;
use reqwest::Client;

/// `DownloadProgress(downloaded, total_size)`
pub struct DownloadProgress(u64, u64);

pub async fn download<F: Fn(DownloadProgress)>(
    client: Client,
    from_url: &str,
    to_path: &str,
    dl_progress_cb: F,
) -> Result<(), Box<dyn Error>> {
    // reference:
    // https://gist.github.com/giuliano-oliveira/4d11d6b3bb003dba3a1b53f43d81b30d

    let res = client.get(from_url).send().await?;
    let total_size = res.content_length().unwrap();

    println!("Download starting, total size {total_size}.");

    let mut file = File::create(to_path)?;
    let mut downloaded = 0;
    let mut stream = res.bytes_stream();

    while let Some(item) = stream.next().await {
        let chunk = item?;
        file.write_all(&chunk)?;

        let new = cmp::min(downloaded + (chunk.len() as u64), total_size);
        downloaded = new;

        dl_progress_cb(DownloadProgress(downloaded, total_size));
    }

    println!("Downloaded {} to {}", from_url, to_path);
    Ok(())
}

pub async fn download_and_run<F: Fn(DownloadProgress)>(
    client: Client,
    from_url: &str,
    filename: &str,
    dl_progress_cb: F,
) -> Result<(), Box<dyn Error>> {
    let res = client.get(from_url).send().await?;
    let total_size = res.content_length().unwrap();

    let mut file = File::create(filename)?;
    let mut downloaded = 0;
    let mut stream = res.bytes_stream();

    while let Some(item) = stream.next().await {
        let chunk = item?;
        file.write_all(&chunk)?;

        let new = cmp::min(downloaded + (chunk.len() as u64), total_size);
        downloaded = new;

        dl_progress_cb(DownloadProgress(downloaded, total_size));
    }

    let status = Command::new("sh")
        .arg("-c")
        .arg(format!("cat {}", filename))
        .spawn()
        .unwrap()
        .wait()?;

    fs::remove_file(filename)?;

    if !status.success() {
        return Err("source failed".into());
    }

    Ok(())
}
