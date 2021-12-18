# ZRS - ZFS Rolling Snapshot

This tool emulates NetApp's rolling snapshots on FreeBSD/Linux ZFS. 
There are other scripts like this but I didn't like their bloat.

## Whats a rolling snapshot?

It's a snapshot that is created on schedule while aging older snapshots.
Lets consider a hourly schedule with maximum 4 snapshots:

```
zfs destroy myvol@hourly3
zfs rename myvol@hourly2 myvol@hourly3
zfs rename myvol@hourly1 myvol@hourly2
zfs rename myvol@hourly0 myvol@hourly1
zfs snapshot myvol@hourly0
```

The oldest snapshot is deleted, other snapshots are progressively aged / 
renamed from 0 to 1, 1 to 2, 2 to 3 etc. Finally a new snapshot 0 is created.

## Usage

* Place `zrs.sh` in a directory accessible via PATH for cron. ZRS is recursive so it will need to call itself by $0.
* Add crontab(5) entries for root. You can come up with any schedule you want. See examples below.

## Example crontab(5) with 4 types

```
0 * * * * zrs.sh myvol hourly  3  # four hourly snapshots
0 0 * * * zrs.sh myvol daily   6  # a week worth of daily snapshots
0 0 * * 0 zrs.sh myvol weekly  3  # month worth if weekly snapshots
0 0 1 * * zrs.sh myvol monthly 11 # a year worth of monthly snapshots
```

Note that `/etc/crontab` has a different format than crontab(5). Crontab format may differ between FreeBSD and Linux.

## Syntax Explanation

* The syntax is: `zrs.sh <volume> <type> <last>`
* Volume is ZFS volume name.
* Type is the name of a schedule for example hourly, daily, weekly, mickey_mouse, donald_duck.
* The 3th parameter is the last snapshot number in sequence starting from 0.
* Example: `zrs.sh myvol hourly 7` will produce 8 snapshots named hourly0 to hourly7

## Legal Stuff

```
Copyright (c) 2021 by Google LLC
This is not an official Google product
License: Apache 2.0
```
