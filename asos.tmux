#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [[ -z $option_value ]]; then
        echo $default_value
    else
        echo $option_value
    fi
}

readonly key="$(get_tmux_option "@asos-key" "C-a")"
readonly nopfx="$(get_tmux_option "@asos-key-noprefix" '')"


tmux bind ${nopfx:+-n} "$key" \
    capture-pane -b asos_in                                                             \\\; \
    save-buffer  -b asos_in "${ASOS_TMPDIR:-/tmp}/asos.in"                              \\\; \
    run-shell    "${CURRENT_DIR}/scripts/comp_asos.sh > ${ASOS_TMPDIR:-/tmp}/asos.out"  \\\; \
    load-buffer  -b asos_out "${ASOS_TMPDIR:-/tmp}/asos.out"                            \\\; \
    send-keys    'C-w'                                                                  \\\; \
    paste-buffer -b asos_out -s ""                                                      \\\; \
    run-shell    "rm ${ASOS_TMPDIR:-/tmp}/{asos.{in,out,allpanes},compword.out}"

