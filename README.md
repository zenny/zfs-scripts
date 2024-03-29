zfs-scripts
===========

Some common scripts I use for ZFS (based on FreeBSD)

##ZPool Health Checker

1st script is for checking your pool health. It provides some common data and emails you.

> health.sh

It assumes your drives have the prefix "ada". If your drives are "ad", you might need to change 1 sed command...

It also assumes you have smartctl loaded, and a way to read your CPU temp (amdtemp_load="YES").


You can set it up to run on a cron job using:

> su

> copy health.sh to /scripts (or some other directory), give right permissions

> crontab -e

> add the line:

> @hourly sh /scripts/health.sh


##ZPool Auto Scrub

2nd script is to automatically scrub specified zpools. I have this setup to run once a month.

> scrubber.sh

You can set it up to run on a cron job using:

> su

> copy to scrubber.sh /scripts (or some other directory), give right permissions

> crontab -e

> add the line:

> 0 0 */45 * * sh /scripts/scrubber.sh




##ZPool balancer

The 3rd script is to attempt to balance your data across all the drives in your pool. If you progressively add drives to a pool, the data that is already written is "stuck" on the original drives. If these drives were "full", it will limit which drives ZFS can read/write to, and lower your potential throughput. This script is by no means perfect.

###Example:

zpool tank has: mirror-1 (100% full), mirror-2 (100% full). You add mirror-3 (0% full). Run the script and it will make it: mirror-1 (33% full), mirror-2 (33% full), mirror-3 (33% full). New writes will then be sent to the three vdevs, instead of the 1.

This script requires a (redundant) location that the data can be copied to with sufficent space for any one folder (aka a seperate pool).


