#!/bin/bash
# Name: Kim Zhao
# Department: School of Human Nutrition
# Email: yuan.z.zhao@mail.mcgill.ca

# Today's date in format YYYMMDD
today=$(date +%Y%m%d)

# argument 1 is the directory where the tar file should be saved:  $1
# argument 2 is an individual file or directory to backup: $2

# Checking if two arguments were given
if [[ $# != 2 ]] 
then
	echo Error: Expected two input parameters.
	echo "Usage: $0 <backupdirectory> <fileordirtobackup>"
	exit 1
fi

# Check if the directory provided exists
if [[ ! -d $1 ]]
then
	echo "Error: The directory $1 does not exist."
	exit 2
# Check if the file or directory to backup exists
elif [[ ! -f $2 ]] && [[ ! -d $2 ]]
then 
	echo "Error: The directory/file '$2' does not exist."
	exit 2
# Check if the directories are the same directories
elif [[ $1 -ef $2 ]]
then
	echo "Error: Both source and destination are the same."
	exit 2
fi

# Strip to only get the last part of $2
cut=${2%}
last=${cut##*/}

# Checking if there is a tar file with the same name
if [[ -f $1/$last.$today.tar ]]
then
	# Asking for confirmation
	echo "Backup file '$last.$today.tar' already exists in '$1'. Overwrite? (y/n)"
	read confirmation
	# If the confirmation does not say 'y', exit with code 3
	if [[ $confirmation != "y" ]]
	then 
		exit 3
	else
		tar -rf "$last.$today".tar -P $2
		mv "$last.$today".tar $1
		exit 0
	fi
fi
# Creating the archive in the current directory
tar -cf "$last.$today".tar -P $2
# Moving the archive to the target directory
mv "$last.$today".tar $1
exit 0
