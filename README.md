# ZRS - ZFS Rolling Snapshot
This tool emulates rolling snapshots of NetApp on ZFS. I wish FreeBSD/ZFS has such
functionality built-in and even turned on by default. Yes, I'm aware there are other
scripts like this but I didn't like their bloat.

## Whats a rolling snapshot?
It's a snapshot taken on a schedule that progresses in time. For example you can
take a snapshot every hour and "age" the previous snapshots till some limit. Imagine
hourly snapshot with limit of 4. Every hour the 4th snapshot is deleted, the 3rd
snapshot becomes 4th, 2nd becomes 3rd, 1st becomes 2nd and finaly a new 1st snapshot
is taken.


## Usage
* Place `zrs.sh` in a directory accessible via PATH for cron. ZRS is recursive so it will need to call itself by $0.
* Add crontab(5) entries for root. You can come up with any schedule you want. See examples below.


## Example crontab(5) with 4 types, 4 snapshot each
    0 * * * * zrs.sh myvol hourly  0 3
    0 0 * * * zrs.sh myvol daily   0 3
    0 0 * * 0 zrs.sh myvol weekly  0 3
    0 0 1 * * zrs.sh myvol monthly 0 3

## Some people like to keep it for a very long time
    0 * * * * zrs.sh myvol hourly  0 47   # 2 days of hourly snapshots
    0 0 * * * zrs.sh myvol daily   0 60   # 2 months of daily snapshots
    0 0 * * 0 zrs.sh myvol weekly  0 11   # 3 months of weekly snapshots
    0 0 1 * * zrs.sh myvol monthly 0 23   # 2 years of monthly snapshots
    0 0 1 1 * zrs.sh myvol yearly  0 4    # 5 yearly snapshots

Note that `/etc/crontab` has a different format than crontab(5).

## Syntax Explanation
* The syntax is: `zrs.sh <volume> <type> 0 <last>`
* Volume is ZFS volume name.
* Type is the name of a schedule for example hourly, daily, weekly, mickey_mouse, donald_duck.
* The 3rd parameter must be always 0. It's used by recursion, do not change it.
* The 4th parameter is the last snapshot number in sequence.
* Example: `zrs.sh myvol hourly 0 7` will produce 8 snapshots named hourly0 to hourly7

ZRS is in Public Domain.
