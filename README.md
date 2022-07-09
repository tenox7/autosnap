# ZFS / BTRFS Auto Snapshot

This script emulates [NetApp Snapshots Schedules](https://library.netapp.com/ecmdocs/ECMP1196991/html/GUID-1D3B0C7D-D94E-43A3-9091-5E76003E16EB.html) on ZFS and BTRFS.

## What is it exactly?

Snapshot are automatically created on schedule, while aging and eventually deleting older snapshots.
As an example lets consider a "hourly" schedule with maximum 4 snapshots:

```
zfs destroy myvol@hourly3
zfs rename myvol@hourly2 myvol@hourly3
zfs rename myvol@hourly1 myvol@hourly2
zfs rename myvol@hourly0 myvol@hourly1
zfs snapshot myvol@hourly0
```

The oldest snapshot `3` is deleted, other snapshots are progressively aged /
renamed from `0 -> 1`, `1 -> 2`, `2 -> 3` etc. Finally a new snapshot `0` is created.

## Why?

Most commonly to protect from accidental file removal or changes, as a undelete, or bring up older version.
Snapshots are NOT backups, but if you delete something it's faster to copy it from a snapshot than recover
from a backup.

## Usage

🛑 **WARNING USE AT YOUR OWN RISK** 🛑  I take no responsibility for any data loss associated with use of these scripts! If used incorrectly the script may delete your volumes and data. Snapshots are not backups. Make sure to back up your data before use. 

* Place either ZFS or BTRFS `autosnap.sh` in a directory accessible via PATH for Cron. The script is recursive so it will need to call itself by `"${0}"`.
* If using BTRFS edit the script and specify mount point and snapshots directory.
* Add crontab(5) entries for root. You can come up with any schedule you want. See examples below.

## Example crontab(5) with 4 types

```
0 * * * * autosnap.sh myvol hourly  3  # four hourly snapshots
0 0 * * * autosnap.sh myvol daily   6  # a week worth of daily snapshots
0 0 * * 0 autosnap.sh myvol weekly  3  # month worth if weekly snapshots
0 0 1 * * autosnap.sh myvol monthly 11 # a year worth of monthly snapshots
```

Note that system `/etc/crontab` has a different format than user crontab(5). Crontab format may also differ between operating systems and cron versions.

## Syntax Explanation

* The syntax is: `zrs.sh <volname> <type> <#max>`
* Volname is a ZFS/BTRFS volume name.
* Type is the name of a schedule for example `hourly`, `daily`, `weekly`, `mickey_mouse`, `donald_duck`. It can also be empty `""` if you have only one schedule.
* The 3rd parameter is the max snapshot number in sequence starting from 0.
* Example: `autosnap.sh mypics hourly 7` will produce 8 snapshots named hourly0 to hourly7

## Legal Stuff

```
Copyright (c) 2021-2022 by Google LLC
This is not an official Google product
License: Apache 2.0
```
