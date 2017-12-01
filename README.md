# ZRS - ZFS Rolling Snapshot
This tool emulates rolling snapshots of NetApp on ZFS. I wish FreeBSD has such
functionality built in but this wasnt the case. I also wish such tool already existed
but this wasnt the case either. Yes, there are some but I didn't like their bloat.

## Whats a rolling snapshot?
It's a snapshot taken on a schedule that progresses in time. For example you can
take a snapshot every hour and age the previous snapshots till the limit. Imagine
hourly snapshot with limit of 4. Every hour the 4th snapshot is deleted, the 3rd
snapshot becomes 4th, 2nd becomes 3rd, 1st becomes 2nd and finaly a new 1st snapshot
is taken.


## Usage
* Place `zrs.sh` in a directory accessible via PATH for cron. ZRS is recursive so it will need to call itself by $0.
* Add crontab(5) entries for root. You can come up with any schedule you want.
* The syntax is: `zrs.sh <volume> <type> 0 <last>`
* Volume is name of ZFS volume.
* Type is the name of a schedule for example hourly, daily, weekly.
* The 3rd parameter must be always 0. Do not change it.
* The last parameter is last snapshot in a sequence.
* Example: `zrs.sh myvol hourly 0 7` will produce 8 snapshots named hourly0 to hourly7

## Example crontab(5) with 4 types 4 snapshot each
    0 * * * * zrs.sh myvol hourly  0 3
    0 0 * * * zrs.sh myvol daily   0 3
    0 0 * * 0 zrs.sh myvol weekly  0 3
    0 0 1 * * zrs.sh myvol monthly 0 3

## Some people like to keep it for a very long time
    0 * * * * zrs.sh myvol hourly  0 47
    0 0 * * * zrs.sh myvol daily   0 60
    0 0 * * 0 zrs.sh myvol weekly  0 11
    0 0 1 * * zrs.sh myvol monthly 0 24

Note that `/etc/crontab` has a different format than crontab(5)

If you want to see how the script works before running, just add `echo` before each zfs call.

ZRS is in Public Domain.
