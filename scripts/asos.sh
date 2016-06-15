#!/usr/bin/env bash

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z $option_value ]; then
        echo $default_value
    else
        echo $option_value
    fi
}

readonly    minlen="$(get_tmux_option "@asos-minlen" "8")"
readonly -a panes=($(tmux list-panes -F '#D'))
readonly    tmpfile=${ASOS_TMPDIR:-/tmp}/asos.allpanes

> "${tmpfile}"

for p in "${panes[@]}"; do
    tmux capturep -p -t "$p" >> "${tmpfile}"
done

awk '{while (NF){length($NF)>='${minlen}' && w[$NF]++;NF--}}
    END {for (k in w) {print k;}}' "${tmpfile}"

