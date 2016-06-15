#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly compword="${1:-$(awk -v RS='' 'END {print $NF;}' ${ASOS_TMPDIR:-/tmp}/asos.in)}"

echo "${compword}" > "${ASOS_TMPDIR:-/tmp}/compword.out"

compgen -W '$('"${CURRENT_DIR}"'/asos.sh)' "${compword}" \
    | awk -v CW="${compword}" '$0 == CW {next;} {seen++;print} END{if(!seen){print CW;}}' \
    | sed -e '$!{N;s/^\(.*\).*\n\1.*$/\1\n\1/;D;}'

