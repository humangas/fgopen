# fileopener
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
"fileopener" is a convenient command line tool to open files using various filters.


# Installation
```
$ git clone https://github.com/humangas/fileopener.git
$ cd fileopener
$ make install
```


# Usage
```
$ fo --help
usage: fo [global options] [options] [path]
version: 0.0.1

options:
    --grep, -g      Open in grep mode
    --fasd, -f      Open from fasd files

path:
    nothing         If not specified, files under the current directory are targeted.
    directory       If you specify a directory, files under that directory are targeted.
    file            If you specify a file, simply open it.

global options:
   --help, -h       Show help
   --version        Show version
```


# Dependencies software
- [fzf](https://github.com/junegunn/fzf)
- [fasd](https://github.com/clvv/fasd)
- [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher)

## Installation
## [fzf](https://github.com/junegunn/fzf#using-homebrew)
```
$ brew install fzf
/usr/local/opt/fzf/install
```

## [fasd](https://github.com/clvv/fasd#install)
```
$ brew install fasd
echo 'eval "$(fasd --init auto)"' >> ~/.zshrc
```

## [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher#macos)
```
$ brew install ag
```
