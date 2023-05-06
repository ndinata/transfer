use std::process::Command;

/// Whether Xcode command-line tools have been installed on this machine.
pub fn has_xcode_tools() -> bool {
    let c = Command::new("xcode-select").arg("-p").output();
    c.is_ok() && c.unwrap().status.success()
}

/// Prints instructions to install Xcode command-line tools to stdout.
pub fn show_xcode_instructions() {
    println!("It seems like you haven't installed Xcode's command-line tools.");
    println!("You can do so by running this command:");
    println!("  xcode-select --install");
    println!("Please try again after you've done this!");
}
