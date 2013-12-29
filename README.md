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




