#!/bin/sh
# ZFS Rolling Snapshot v1.1 by Antoni Sawicki. Apache 2.0.
[ ${#} -lt 3 ] && { echo "usage: $0 <volume> <type> <last>"; exit; }
[ ${4:-0} -lt ${3} ] && ${0} ${1} ${2} ${3} $((${4:-0}+1))
[ ${4:-0} -eq ${3} ] && zfs destroy "${1}@${2}${4:-0}"
[ ${4:-0} -gt 0 ] && zfs rename "${1}@${2}$((${4:-0}-1))" "${1}@${2}${4:-0}"
[ ${4:-0} -eq 0 ] && zfs snapshot "${1}@${2}${4:-0}"
