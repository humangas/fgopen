# fgopen
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
"fgopen" is a cli tool that uses find, [ag(grep)](https://github.com/ggreer/the_silver_searcher#macos), [fzf](https://github.com/junegunn/fzf#using-homebrew) to open locate files quickly.


## Installation
```
$ git clone https://github.com/humangas/fgopen.git
$ cd fgopen
$ make install
```


## Usage
```
$ fgo --help
Usage: fgo [--version] [--help] [options] [path]
Version: 0.4.0

Options:
    --grep, -g       grep mode
    --batch, -b      batch mode 

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
