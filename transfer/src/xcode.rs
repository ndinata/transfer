use std::process::Command;

/// Whether Xcode command-line tools have been installed on this machine.
pub fn require_xcode_tools() -> bool {
    let c = Command::new("xcode-select").arg("-p").output();
    c.is_err() || !c.unwrap().status.success()
}

/// Prints instructions to install Xcode command-line tools to stderr.
pub fn show_xcode_instructions() {
    eprintln!("It seems like you haven't installed Xcode's command-line tools.");
    eprintln!("You can do so by running this command:");
    eprintln!("  xcode-select --install");
    eprintln!("Please try again after you've done this!");
}
