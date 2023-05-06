use serde::Deserialize;

/// The configuration schema for "reminders": things that the user might want to
/// come back to after this program finishes, e.g. things that need to be run
/// after a shell/machine restart.
#[derive(Debug, Deserialize, PartialEq)]
pub struct Remindable {
    pub instruction: String,
    pub command: String,
}

impl Remindable {
    /// Prints the reminder's instruction and command.
    pub fn display_reminder(&self, count: usize) {
        println!("{}. {}", count, self.instruction);
        println!("$ {}\n", self.command);
    }
}
