#!/bin/sh
# ZFS Rolling Snapshot v1.0 Antoni Sawicki. This file is Public Domain.
[ $# -ne 4 ] && { echo "usage: $0 <volume> <type> 0 <last>"; exit; }
[ ${3} -lt ${4} ] && ${0} ${1} ${2} $((${3}+1)) ${4}
[ ${3} -eq ${4} ] && echo zfs destroy "${1}@${2}${3}"
[ ${3} -gt 0 ] && echo zfs rename "${1}@${2}$((${3}-1))" "${1}@${2}${3}"
[ ${3} -eq 0 ] && echo zfs snapshot "${1}@${2}${3}"
