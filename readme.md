# Transfer

Transfer is a simple command-line program made with the goal of setting up my personal macOS dev environment, e.g. after a factory reset/on a new machine.

This program helps me automate:

- installing my CLI and GUI apps programmatically via Homebrew,
- downloading remote files to the new dev env,
- copying dotfiles and other config files to the new dev env, and
- running scripts to, for example, configure some macOS settings via the CLI

I made this for my own personal use, although hopefully it's flexible enough to also be useful to others. Read the [config](#config) section below for details on how to adjust the program's default behaviour to match your needs.

## Config

The two files that determine the program's behaviour are [`config/Brewfile`](config/Brewfile) and [`config/config.toml`](config/config.toml).

### Homebrew

This program currently assumes a brand new empty environment, so it's going to install Homebrew first and foremost. Afterwards, it will try to install the bundle in [`config/Brewfile`](config/Brewfile) (the default location). If this file doesn't exist, the program will halt. There is no way to skip this step at the moment, although you _can_ adjust what programs to be installed in the Brewfile, including making it empty so the bundle install step is effectively skipped!

### Other behaviours

In addition to Homebrew, Transfer supports doing the following operations:

- copying files to the new dev environment,
- downloading remote files,
- running scripts

These other behaviours can be customised by editing the [`config/config.toml`](config/config.toml) file containing these four sections: `copy`, `download`, `run`, and `reminders`. If this file doesn't exist, the program will halt. However, you can skip these operations by making the sections be an empty array — more details on how to configure each section is available in the file itself.

## Usage

This program has been tested only on macOS, so running it on other platforms may do whatever! To run it, you would need these first:

- Internet connection,
- stable Rust [toolchain](https://rustup.rs),
- Xcode command-line tools (will be prompted by the program if you don't have it),

Then do this:

```sh
$ git clone https://github.com/nictar/transfer.git
$ cd transfer
# before running the line below, update `config/config.toml` or `config/Brewfile` to adjust program behaviour according to your needs
$ cargo run --release
```

## Roadmap

Todos:

- [ ] Allow overriding config file location via CLI flag
- [ ] Improved error logging (to files)
- [ ] Add dry-run mode
- [ ] Prettier (T)UI

Non-goals:

- support for non-macOS platforms
- advanced error recovery: if things fail, rather than trying to fix errors on-the-spot, the program will defer to simply notifying the user about them. Example: if trying to copy to a dir you (the user) don't have write permissions for, the program will just skip the copy and notify you about this

## License

Licensed under the [MIT license](license).

## Learning

This section talks about the learning/reflection aspect of this project (e.g. why I wrote it, what I learned), so if you're only interested in using the program, feel free to skip this part!

If you're reading this you're probably wondering "why not Bash since you're wrapping it anyways?" or "why not Python if you wanted a higher-level lang?"

I did write this program as a collection of Bash scripts [at first](https://github.com/nictar/transfer/tree/deprecated/wake)! I then decided to rewrite this in Rust because I'm currently learning it, so this is a practical project I can practise working with the language in! I get: 1. a useful program I actually can use, and 2. better (hopefully) at writing programs in the language I wanna be proficient in. Win-win!

Writing Transfer in Rust first impressions:

- compiler error messages are the real MVPs
- Rust's ownership hasn't bitten me as often as I thought it would (although kinda expected since I'm just... printing things and calling shell commands for the most part)
- crate examples tend to be in succinct code excerpts in [docs.rs](https://docs.rs) rather than the more comprehensive ones I'm used to from `npm` packages — a bit of a challenge but I think I learned a lot more about crates I use because of this!
- Rust's high-level features (pattern matching, `map` etc.) have made this journey really enjoyable! Despite Rust usually being associated with lower-level programming, I found that scripting in it isn't all that terrible
