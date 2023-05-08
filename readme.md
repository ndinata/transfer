# Transfer

Transfer is a simple command-line program made with the goal of setting up my macOS dev environment, e.g. after a factory reset/on a new machine.

This program helps me automate:

- installing my CLI and GUI apps programmatically via Homebrew,
- copying dotfiles and other config files to the new dev env, and
- running domain-specific setup scripts to, for example, configure some macOS settings via the CLI

Read the [config](#config) section for more details on the program's behaviour.

## Config

### Homebrew

This program currently assumes a brand new environment, so Homebrew is going to be installed by default. The default Brewfile location that the program will try to read from is `config/Brewfile`. If this file doesn't exist, the program will halt.

### Other behaviours

In addition to Homebrew, Transfer supports doing the following operations:

- copying files to the new dev environment,
- downloading remote files,
- running scripts

## Usage

This program has been tested only on macOS, so running it on other platforms may do whatever! It is pretty stable now, although new features and improvements are planned. The program handles only simple configs though, so if you pass funky items into it the program might do unexpected things.

If you want to run it, you would need these first:

- Internet connection,
- stable Rust [toolchain](https://rustup.rs),
- Xcode command-line tools (will be prompted by the program if you don't have it),

Then do this:

```sh
$ git clone https://github.com/nictar/transfer.git
$ cd transfer
$ cargo run --release
```

## Roadmap

TODO:

- [ ] Allow overriding config file location via CLI flag
- [ ] Improved logging (to files)
- [ ] Add dry-run mode
- [ ] Prettier (T)UI

Non-goals:

- support for non-macOS platforms
- advanced error recovery: if things fail, rather than trying to fix errors on-the-spot, the program will defer to simply notifying the user about them. Example: if trying to copy to a dir you (the user) don't have write permissions for, the program will just skip the copy and notify you about this

## Learning

This section talks about the learning/reflection aspect of this project (e.g. why I wrote it, what I learned), so if you're only interested in using the program, feel free to skip this part!

If you're reading this you're probably wondering "why not Bash since you're wrapping it anyways?" or "why not Python if you wanted a higher-level lang?"

Well, I wrote this in Rust because I'm currently learning it, so this is a practical project I can practise working with the language in! I get: (a) a useful program I actually use, and (b) better (hopefully) at writing programs in the language I wanna be proficient in. Win-win!

Writing `transfer` in Rust first impressions:

- compiler error messages are the real MVPs
- Rust's ownership doesn't bite me as often as I thought it would (although expected since I'm just... printing things and calling shell commands for the most part)
- Cargo workspaces is neat
- high-level features (pattern matching, `map` etc.) have made this journey enjoyable
- Availability and diversity of crates reminds me of [npm](https://www.npmjs.com), although most of the crates I've encountered in contrast don't really provide detailed docs and examples in English; they provide them in code in [docs.rs](https://docs.rs) instead. Have had to download and run the examples locally way more than I used to do with JS/TS packages, which is an interesting new experience.
