# findgrep
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
"findgrep" is a cli tool that uses find, grep(ag), fzf to quickly locate files.


## Installation
```
$ git clone https://github.com/humangas/findgrep.git
$ cd findgrep
$ make install
```


## Usage
```
$ fing --help
Usage: fing [--version] [--help] [options] [path]
Version: 0.2.1

Options:
    --grep, -g       Open in grep mode

Keybind:
    ctrl+u           Page half Up
    ctrl+d           Page half Down
    ctrl+f           Switch grep mode and file selection mode
    ctrl+i, TAB      Select multiple files. Press ctrl+i or shift+TAB to deselect it
    ctrl+a           Select all
    ctrl+q, ESC      Leave processing

```


## Dependencies software
- bash: >= 4.0.0
- [fzf](https://github.com/junegunn/fzf)
- [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher)

### Installation
#### bash
```
$ brew install bash
$ sudo echo '/usr/local/bin/bash' >> /etc/shells
```

#### [fzf](https://github.com/junegunn/fzf#using-homebrew)
```
$ brew install fzf
/usr/local/opt/fzf/install
```

#### [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher#macos)
```
$ brew install ag
```
