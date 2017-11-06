#!/usr/bin/env bash

FGO_APPNAME="fgo"
FGO_VERSION="0.4.0"
FGO_FZF_CMD="fzf-tmux"
FGO_FIND_OPTIONS="-type d -name .git -prune -o -type f -print"
FGO_FIND_PIPE_CMD="" #e.g. egrep \.go 
FGO_GREP_CMD="ag"
FGO_GREP_OPTIONS="--hidden --ignore .git/ . "
FGO_CONFIRM_OPEN_FILE_CNT=5


function _usage() {
echo "Usage: $FGO_APPNAME [--version] [--help] [options] [path]
Version: $FGO_VERSION

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
"
    exit 0
}

function _version(){
    echo "$FGO_APPNAME $FGO_VERSION"
    exit 0
}

function _error_options() {
    echo "Error \"$1\" is no such option"
    echo "--> more info with: $FGO_APPNAME --help"
    exit 1
}

function _options() {
    while getopts ":vhgb-:" opt; do
        case "$opt" in
            -)  # logn option
                case "${OPTARG}" in
                    help) _usage ;;
                    version) _version ;;
                    grep) GETOPTS_G=1 ;;
                    batch) GETOPTS_B=1 ;;
                    *) _error_options "--$OPTARG" ;;
                esac
                ;;
            h) _usage ;;
            v) _version ;;
            g) GETOPTS_G=1 ;;
            b) GETOPTS_B=1 ;;
            *) _error_options "-$OPTARG" ;;
        esac
    done   

    shift $((OPTIND - 1))
    V_PATH=$1
    if [[ ! (-z "$V_PATH" || -e "$V_PATH") ]]; then
        echo "Error \"$V_PATH\" is not foud"
        exit 1
    fi
}

function _filefilter() {
    [[ ! -z "$FGO_FIND_PIPE_CMD" ]] && FGO_FIND_PIPE_CMD="| $FGO_FIND_PIPE_CMD"

    local spath=${1:-$PWD}
    if [[ -f $spath ]]; then
        f="$(basename $spath)"
        _grep "$(dirname $spath)"
        return
    fi

    local select
    IFS=$'\n' select=($(eval find $spath $FGO_FIND_OPTIONS $FGO_FIND_PIPE_CMD \
        | sed -e "s@$spath/@@" \
        | $FGO_FZF_CMD --multi --cycle \
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
            if [[ $_open_file_cnt -gt $FGO_CONFIRM_OPEN_FILE_CNT && ! $GETOPTS_B ]]; then
                echo -n "Really open $_open_file_cnt files? [Y/n]: "
                read ans
                case $ans in
                    'Y'|'yes') ;;
                    *) return ;;
                esac
            fi

            declare -a vimfiles
            declare -a etcfiles
            [[ ! "$GETOPTS_B" ]] && echo "Open the following file..."

            for f in $files; do
                echo "$spath/$f"
                isText $spath/${f}
                retval=$?
                [[ $retval -eq 0 ]] && vimfiles+=($spath/${f}) || etcfiles+=($spath/${f})
            done

            if [[ ! "$GETOPTS_B" ]]; then
                [[ $((${#etcfiles[@]})) -ge 1 ]] && open ${etcfiles[@]}
                [[ $((${#vimfiles[@]})) -ge 1 ]] && vim ${vimfiles[@]}
            fi
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
                _grep_options="-G $ag_gop $FGO_GREP_OPTIONS"
            fi

            _grep "$spath" $_grep_options
            ;;

        *)
            return
            ;;
    esac
}

function _grep() {
    local spath=${1:-$PWD}
    local _grep_options=${2:-$FGO_GREP_OPTIONS $f}

    (
        cd $spath
        local line=$(eval $FGO_GREP_CMD $_grep_options \
            | $FGO_FZF_CMD --tac \
                --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-y:yank \
                --expect=ctrl-f)
        [[ -z $line ]] && return
        [[ $line =~ ^ctrl-f\s*.* ]] && _filefilter $spath && return

        local file
        local num
        file=$(printf $line | cut -d: -f1)
        num=$(printf $line | cut -d: -f2)
        if expr "$file" : '[0-9]*' > /dev/null ; then
            num=$file
            file=$f
        fi
        
        if [[ ! "$GETOPTS_B" ]]; then
            vim -c $num $spath/$file
        else
            echo $line
        fi
    )
}

function isText() {
    local filepath="$1"
    [[ -z $filepath ]] && return 1

    local type=$(file "$filepath" | cut -d: -f2 | grep 'text')
    [[ -z $type ]] && return 1
    [[ ${#type} -ne 0 ]] && return 0

    return 1
}

function main() {
    _options "$@"
    if [[ "$GETOPTS_G" ]]; then
        if [[ -d "$V_PATH" ]]; then
            local dirpath="$V_PATH"
            local grep_options=""
        fi
        if [[ -f "$V_PATH" ]]; then
            f="$(basename $V_PATH)"
            local dirpath=$(dirname $V_PATH)
            local grep_options="$FGO_GREP_OPTIONS $f"
        fi
        _grep "$dirpath" "$grep_options"
        exit $?
    fi

    _filefilter "$V_PATH"
    exit $?
}

# main
main "$@"
