use std::process::Command;

pub fn require_xcode_tools() -> bool {
    let c = Command::new("xcode-select").arg("-p").output();
    c.is_err() || !c.unwrap().status.success()
}

pub fn show_xcode_instructions() {
    println!("It seems like you haven't installed Xcode's command-line tools.");
    println!("You can do so by running this command:");
    println!("  xcode-select --install");
    println!("Please try again after you've done this!");
}
