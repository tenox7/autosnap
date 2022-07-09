#!/bin/sh
# BTRFS Auto Snapshot v1.0 written by Antoni Sawicki. License Apache 2.0.
# Copyright (c) 2022 Google LLC.; This is not an official Google product.
M="/data" # btrfs mount path
S=".snapshots" # snapshots path
[ ${#} -lt 3 ] && { echo "usage: $0 <volname> <type> <#max>"; exit; }
[ ${4:-0} -lt ${3} ] && "${0}" "${1}" "${2}" "${3}" "$((${4:-0}+1))"
[ ${4:-0} -eq ${3} ] && btrfs subvolume delete "${M}/${S}/${1}@${2}${4:-0}"
[ ${4:-0} -gt 0 ] && mv "${M}/${S}/${1}@${2}$((${4:-0}-1))" "${M}/${S}/${1}@${2}${4:-0}"
[ ${4:-0} -eq 0 ] && btrfs subvolume snapshot -r "${M}/${1}" "${M}/${S}/${1}@${2}${4:-0}"
