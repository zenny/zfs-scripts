#!/usr/local/bin/bash
# written by Alex Stundzia
# alex@stundzia.com, twitter: @stundzia

# This is currently configured as an example. Consider the directory "/tank/pictures"
# is filled with photos that mostly reside on drives that are "old" in the pool.
# You just added a new redundant set of disks, and wish to "balance" this data across
# all disks in the pool. The temporary directory must be a directory that resides on a
# different pool with sufficient space to host any given folder under the directory.


#make sure to leave trailing /
DIRECTORY_TO_COPY='/tank/pictures/'
TEMPORARY_DIRECTORY='/temp/pictures/'

LENGTH_OF_DIRECTORY_PREFIX="${#DIRECTORY_TO_COPY}"

mkdir -p $TEMPORARY_DIRECTORY

find $DIRECTORY_TO_COPY -print -maxdepth 1 -mindepth 1 |  cut -c $(($LENGTH_OF_DIRECTORY_PREFIX+1))-1700 |
        while read file
        do
                echo "Moving "$file" to temp directory..."
                mv -v "$DIRECTORY_TO_COPY$file" $TEMPORARY_DIRECTORY
                echo "Moving file back to original directory..."
                mv -v "$TEMPORARY_DIRECTORY$file" $DIRECTORY_TO_COPY
        done
