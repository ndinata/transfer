# Transfer

Transfer is a command-line program with the goal of setting up my macOS dev environment, e.g. after a factory reset/on a new machine.

This program helps me automate:

- installing my CLI and GUI apps programmatically via Homebrew,
- copying dotfiles and other config files to the new dev env, and
- running domain-specific setup scripts to, for example, configure some macOS settings via the CLI

Read the [config](#config) section for more details on the program's behaviour.

## Config

TODO!

## Usage

This program is currently **not** ready for actual use yet (it's pretty close tho)! Every commit might introduce breaking changes, and adding funky items to the program config might make it do crazy things.

Nevertheless, if you still want to run it, you would need these:

- `cargo` installed
- Internet connection

Then do this:

```sh
$ git clone https://github.com/nictar/transfer.git
$ cd transfer
$ cargo run --release
```

If you ran the program at its current state and your machine catches on fire, I warned you!

## Roadmap

Goals:

- [ ] Warn about `xcode-select --install` prerequisite
- [ ] Improved logging (to files)
- [ ] Prettier (T)UI

Non-goals:

- TODO!
- TODO!

## Attributions

TODO!

## Learning

This section talks about the learning/reflection aspect of this project (e.g. why I wrote it, what I learned), so if you're only interested in using the program, feel free to skip this part!

If you're reading this you're probably wondering "why not Bash since you're wrapping it anyways?" or "why not Python if you wanted a higher-level lang?"

Well, I wrote this in Rust because I'm currently learning it, so this is a practical project I can practise working with the language in! I get: (a) a useful program I actually use, and (b) better (hopefully) at writing programs in the language I wanna be proficient in. Win-win!

Writing `transfer` in Rust first impressions:

- compiler error messages are the real MVPs
- Rust's ownership doesn't bite me as often as I thought it would (although expected since I'm just... printing things and calling shell commands for the most part)
- Cargo workspaces is neat
- high-level features (pattern matching, `map` etc.) make this journey enjoyable!
