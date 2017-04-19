#!/usr/bin/env bash

FO_APPNAME="fo"
FO_VERSION="0.1.0"
FO_FZF_CMD="fzf-tmux"
FO_FIND_OPTIONS="-type d -name .git -prune -o -type f -print"
FO_FIND_PIPE_CMD="" #e.g. egrep \.go 
FO_GREP_CMD="ag"
FO_GREP_OPTIONS="--hidden --ignore .git/ . "
FO_CONFIRM_OPEN_FILE_CNT=5


function _usage() {
echo "usage: $FO_APPNAME [global options] [options] [path]
version: $FO_VERSION

options:
    --grep, -g       Open in grep mode
    --fasd, -f       Open from fasd files

path:
    nothing          If not specified, files under the current directory are targeted.
    directory        If you specify a directory, files under that directory are targeted.
    file             If you specify a file, simply open it.

global options:
    --help, -h       Show help
    --version        Show version

keybind:
    ctrl+u           Page half Up
    ctrl+d           Page half Down
    ctrl+a           Select all
    ctrl+i, TAB      Select multiple files. Press ctrl+i or shift+TAB to deselect it.
    ctrl+f           Open the selected file in grep mode. 
                     Pressing ctrl+f in grep mode puts you in file selection mode.
    ctrl+q, ESC      Leave processing
"
}

function _version(){
    echo "$_FO_APPNAME $_FO_VERSION"
}

function main() {
    local spath
    for opt in "$@"; do
        case "$opt" in
            '-h'|'--help') _usage && exit 0 ;;
            '--version')   _version && exit 0 ;;
            '-g'|'--grep') 
                if [[ -z $spath ]]; then
                    shift 1; spath=$1
                fi
                _grep "$spath"; exit $? ;;
            '-f'|'--fasd')
                _fasd; exit $? ;;
            -*) 
                echo "Error $opt is no such option"
                echo "--> more info with: $_FO_APPNAME --help"
                exit 1
                ;;
            *)
                if [[ ! -e $opt ]]; then
                    echo "Error $opt is not found"
                    exit 1
                fi
                spath=$opt
                ;;
        esac
    done

    _filefilter "$@"
    exit $?
}

function _filefilter() {
    [[ ! -z "$_FO_FIND_PIPE_CMD" ]] && _FO_FIND_PIPE_CMD="| $_FO_FIND_PIPE_CMD"

    local spath=${1:-$PWD}
    if [[ -f $spath ]]; then
        isText $spath && vim $spath || open $spath
        return
    fi

    local select
    IFS=$'\n' select=($(eval find $spath $_FO_FIND_OPTIONS $_FO_FIND_PIPE_CMD \
        | sed -e "s@$spath/@@" \
        | $_FO_FZF_CMD --multi --cycle \
        --preview "less -R $spath/{}" \
        --bind=ctrl-a:select-all,ctrl-a:toggle-all,ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-y:yank \
        --expect=enter,ctrl-f \
    ))

    key=$(head -1 <<< "$select")
    file=$(head -2 <<< "$select" | tail -1)
    declare files="${select[@]:1}"

    declare -a filesx
    for f in $files; do
        isText "$spath/$f" && filesx+=($f)
    done

    _fileaction $spath $key $((${#filesx[@]}))
}

function _fileaction() {
    local spath=$1
    local key=$2
    local scnt=$3

    case $key in
        enter)
            [[ -z ${files[@]} ]] && return

            local _open_file_cnt=$((${#select[@]}-1))
            if [[ $_open_file_cnt -gt $_FO_CONFIRM_OPEN_FILE_CNT ]]; then
                echo -n "Really open $_open_file_cnt files? [Y/n]: "
                read ans
                case $ans in
                    'Y'|'yes') ;;
                    *) _filefilter $spath && return ;;
                esac
            fi

            declare -a vimfiles
            declare -a etcfiles
            echo "Open the following file..."

            for f in $files; do
                echo "$spath/$f"
                isText $spath/${f}
                retval=$?
                [[ $retval -eq 0 ]] && vimfiles+=($spath/${f}) || etcfiles+=($spath/${f})
            done

            [[ $((${#etcfiles[@]})) -ge 1 ]] && open ${etcfiles[@]}
            [[ $((${#vimfiles[@]})) -ge 1 ]] && vim ${vimfiles[@]}
            ;;

        ctrl-f)
            [[ -z ${filesx[@]} ]] && _filefilter $spath && return

            declare -a _target_files
            for f in $files; do
                _target_files+=($f)
                _target_files+=("|")
            done

            local _grep_options
            if [[ $scnt -gt 1 ]]; then
                local ag_gop=$(echo "'${_target_files[@]:0:((${#_target_files[@]}-1))}'" | sed -e 's/ //g')
                _grep_options="-G $ag_gop $_FO_GREP_OPTIONS"
            else
                _grep_options="$_FO_GREP_OPTIONS $f"
            fi

            (
                cd $spath
                local line=$(eval $_FO_GREP_CMD $_grep_options \
                    | $_FO_FZF_CMD --tac \
                        --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-y:yank \
                        --expect=ctrl-f)
                [[ -z $line ]] && _filefilter $spath && return
                [[ $line =~ ^ctrl-f\s*.* ]] && _filefilter $spath && return

                local file
                local num
                if [[ $scnt -gt 1 ]]; then
                    file=$(printf $line | cut -d: -f1)
                    num=$(printf $line | cut -d: -f2)
                else
                    file=${filesx[@]}
                    num=$(printf $line | cut -d: -f1)
                fi

                vim -c $num $spath/$file
            )
            ;;

        *)
            return
            ;;
    esac
}

function _grep() {
    local spath=${1:-$PWD}
    local _grep_options="$_FO_GREP_OPTIONS $f"

    (
        cd $spath
        local line=$(eval $_FO_GREP_CMD $_grep_options \
            | $_FO_FZF_CMD --tac \
                --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-y:yank \
                --expect=ctrl-f)
        [[ -z $line ]] && _filefilter $spath && return
        [[ $line =~ ^ctrl-f\s*.* ]] && _filefilter $spath && return

        local file
        local num
        file=$(printf $line | cut -d: -f1)
        num=$(printf $line | cut -d: -f2)
        
        vim -c $num $spath/$file
    )
}

function _fasd() {
    local f="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)"
    [[ -z "$f" ]] && return 1

    isText "$f"
    retval=$?
    [[ $retval -eq 0 ]] && vim "$f" || open "$f"
}

function isText() {
    local filepath="$1"
    [[ -z $filepath ]] && return 1

    local type=$(file "$filepath" | cut -d: -f2 | grep 'text')
    [[ -z $type ]] && return 1
    [[ ${#type} -ne 0 ]] && return 0

    return 1
}

# main
main "$@"
