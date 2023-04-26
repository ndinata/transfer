use serde::Deserialize;

#[derive(Debug, Deserialize, PartialEq)]
pub struct Remindable {
    pub instruction: String,
    pub command: String,
}

impl Remindable {
    pub fn display_reminder(&self, count: usize) {
        println!("{}. {}", count, self.instruction);
        println!("$ {}", self.command);
    }
}
