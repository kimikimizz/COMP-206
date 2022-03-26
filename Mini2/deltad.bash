#!/bin/bash
# Name: Kim Zhao
# Department: School of Human Nutrition
# Email: yuan.z.zhao@mail.mcgill.ca

# Checking if two arguments were given
if [[ $# != 2 ]]
then
	echo Error: Expected two input parameters.
	echo "Usage: $0 <backupdirectory> <fileordirtobackup>"
	exit 1
fi
# Checking if $1 is a valid directory
if [[ ! -d $1 ]]
then
	echo "Error: Input parameter #1 $1 is not a directory"
	echo "Usage: $0 <originaldirectory> <comparisondirectory>"
	exit 2
# Checking if $2 is a valid directory
elif [[ ! -d $2 ]]
then
	echo "Error: Input parameter #2 $2 is not a directory"
	echo "Usage: $0 <originaldirectory> <comparisondirectory>"
	exit 2
# Checking if $1 and $2 are the same directory
elif [[ $1 -ef $2 ]]
then
	echo "Error: The directories $1 and $2 are the same"
	echo "Usage: $0 <originaldirectory> <comparisondirectory>"
	exit 2
fi

# Checking the contents of directory 1
differ=false
for file1 in $(ls $1)
do
	# If it is a subdirectory, ignore it
	if [[ -d $1/$file1 ]]
	then
		continue
	fi	
	# Checking if a file with the same name exists in directory 2
	if [[ -f $2/$file1 ]]
	then
		# Checking if the two files have the same content
		difference=$(diff $1/$file1 $2/$file1)	
		if [[ "$difference" != "" ]]
		then
			echo "$1/$file1 differs"
			differ=true
		fi
	# If a file doesn't exist in directory 2, print that it is missing
	else
		echo "$2/$file1 is missing"
		differ=true
		
	fi
done

# Checking the contents of directory 2
for file2 in $(ls $2)
do
	# If the file is not a directory and is absent in directory 1
	if [[ ! -f $1/$file2 ]] && [[ ! -d $1/$file2 ]]
	then 
		# print that it is missing
		echo "$1/$file2 is missing"
		differ=true
	fi
done

# If the two directories differ in content, exit with code 3
if [[ "$differ" == "true" ]]
then
	exit 3
fi
# Otherwise, exit with code 0
exit 0
