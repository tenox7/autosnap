#!/bin/sh
# BTRFS Auto Snapshot v1.0 written by Antoni Sawicki. License Apache 2.0.
# Copyright (c) 2022 Google LLC.; This is not an official Google product.
MNT="/data" # btrfs mount path
SNP=".snapshots" # snapshots path
[ ${#} -lt 3 ] && { echo "usage: $0 <volname> <type> <#max>"; exit; }
[ ${4:-0} -lt ${3} ] && "${0}" "${1}" "${2}" "${3}" "$((${4:-0}+1))"
[ ${4:-0} -eq ${3} ] && btrfs subvolume delete "${MNT}/${SNP}/${1}@${2}${4:-0}"
[ ${4:-0} -gt 0 ] && mv "${MNT}/${SNP}/${1}@${2}$((${4:-0}-1))" "${MNT}/${SNP}/${1}@${2}${4:-0}"
[ ${4:-0} -eq 0 ] && btrfs subvolume snapshot -r "${MNT}/${1}" "${MNT}/${SNP}/${1}@${2}${4:-0}"
