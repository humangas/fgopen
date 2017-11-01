# fileopener
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
"fileopener" is a convenient command line tool to open files using various filters.


## Installation
```
$ git clone https://github.com/humangas/fileopener.git
$ cd fileopener
$ make install
```


## Usage
```
$ fo --help
Usage: fo [global options] [options] [path]
version: 0.2.1

Options:
    --grep, -g       Open in grep mode

Path:
    {nothing}        If not specified, files under the current directory are targeted.
    {directory}      If you specify a directory, files under that directory are targeted.
    {file}           If you specify a file, simply open it.

Global Options:
    --help, -h       Show help
    --version        Show version

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
- [fasd](https://github.com/clvv/fasd)
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
