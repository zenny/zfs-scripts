#!/usr/local/bin/bash

# define your email address:
MAIL_TO='your@email.com'

# define other variables if needed
ZPOOL_LOCATION='/sbin/zpool'
SYSCTL_LOCATION='/sbin/sysctl'
REPORT_LOCATION='/tmp/report.txt'
SMARTCTL_LOCATION='/usr/local/sbin/smartctl'
AWK_LOCATION='awk'
SED_LOCATION='sed'
IMPORTANCE_VAR=''


status_report_header()
{
        echo "System Status Report" > $REPORT_LOCATION
        line_break
}

get_uptime()
{
        UPTIME_VAR=$(uptime)
        echo "Up Time:" >> $REPORT_LOCATION
        echo $UPTIME_VAR >> $REPORT_LOCATION
}

check_zpool_status()
{
        line_break
        ZPOOL_STATUS=$($ZPOOL_LOCATION status -x | grep 'all pools are healthy')
        echo "ZPool Status:" >> $REPORT_LOCATION
        if [ "$ZPOOL_STATUS" == "all pools are healthy" ]; then
                echo 'All Pools are healthy.' >> $REPORT_LOCATION
    else
                echo 'ZPool Issue Detected!' >> $REPORT_LOCATION
                IMPORTANCE_VAR='ZFS Critical:'
                $ZPOOL_LOCATION status -xv >> $REPORT_LOCATION
        fi
}

get_cpu_temp()
{
        line_break
        CPU_TEMP_OUT=$($SYSCTL_LOCATION -a | grep -i "dev.cpu.[0-9].temp" | $SED_LOCATION 's/C//' | $SED_LOCATION                                                                                                                            's/^.......................//' | $AWK_LOCATION '{sum+=$0} END {print "",sum/NR}' | $SED_LOCATION -e 's/^[ \t]*//')
        echo 'CPU Temp: '$CPU_TEMP_OUT' C' >> $REPORT_LOCATION
}

get_hdd_temps()
{
        line_break
        for i in `egrep 'ada[0-9]' /var/run/dmesg.boot | $SED_LOCATION -n '/^ada[0-9]/p' | $AWK_LOCATION -F ' ' '{                                                                                                                           print $1}' | $AWK_LOCATION -F ':' '{print $1}' | $AWK_LOCATION 'seen[$0]++ == 1'`; do
                TEMP_VAR=$($SMARTCTL_LOCATION -A /dev/$i | grep '194 Temperature' | $AWK_LOCATION '{print $10}')

                if [ $TEMP_VAR ]; then

                        if [ -n "$MIN_VAR" ]; then
                        else
                                MIN_VAR=$(($TEMP_VAR))
                                MAX_VAR=$(($TEMP_VAR))
                                AVG_VAR='0'
                        fi

                        if [ "$TEMP_VAR" -lt "$MIN_VAR" ]; then
                                MIN_VAR=$TEMP_VAR
                                MIN_HDD=$i
                        fi

                        if [ "$TEMP_VAR" -gt "$MAX_VAR" ]; then
                                MAX_VAR=$TEMP_VAR
                                MAX_HDD=$i
                        fi

                        AVG_VAR=$(($AVG_VAR+$TEMP_VAR))
                        HDD_COUNT=$(($HDD_COUNT+1))
                fi
        done

        AVG_VAR=$(($AVG_VAR/$HDD_COUNT))
        echo 'Min HDD Temp: '$MIN_VAR' C ('$MIN_HDD')' >> $REPORT_LOCATION
        echo 'Max HDD Temp: '$MAX_VAR' C ('$MAX_HDD')' >> $REPORT_LOCATION
        echo 'Avg HDD Temp: '$AVG_VAR' C' >> $REPORT_LOCATION
}

line_break()
{
        echo '' >> $REPORT_LOCATION
}

tail_dmesg()
{
        echo '' >> $REPORT_LOCATION
        echo 'Last 20 Lines of dmesg' >> $REPORT_LOCATION
        cat /var/log/messages | tail -n 20 >> $REPORT_LOCATION
}

email_report()
{
        TITLE_VAR=$(echo $IMPORTANCE_VAR Server Status Report)
        cat $REPORT_LOCATION | mail -s "$TITLE_VAR" $MAIL_TO
}

status_report_header
get_uptime
check_zpool_status
get_cpu_temp
get_hdd_temps
tail_dmesg
email_report
