#!/bin/sh
# ZFS Auto Snapshot v1.1 written by Antoni Sawicki. License Apache 2.0.
# Copyright (c) 2022 Google LLC. This is not an official Google product.
[ ${#} -lt 3 ] && { echo "usage: $0 <volname> <type> <#max>"; exit; }
[ ${4:-0} -lt ${3} ] && "${0}" "${1}" "${2}" "${3}" "$((${4:-0}+1))"
[ ${4:-0} -eq ${3} ] && zfs destroy "${1}@${2}${4:-0}"
[ ${4:-0} -gt 0 ] && zfs rename "${1}@${2}$((${4:-0}-1))" "${1}@${2}${4:-0}"
[ ${4:-0} -eq 0 ] && zfs snapshot "${1}@${2}${4:-0}"
