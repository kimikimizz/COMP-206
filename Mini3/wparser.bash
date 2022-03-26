#!/bin/bash
# Name: Kim Zhao
# Department: School of Human Nutrition
# Email: yuan.z.zhao@mail.mcgill.ca

# Checking the number of arguments
if [[ $# != 1 ]]
then
	echo "Usage $0 <weatherdatadir>"
	exit 1
fi

# Checking whether the argument is a valid directory
if [[ ! -d $1 ]]
then
	echo "Error! $1 is not a valid directory name" >/dev/stderr
	exit 1
fi

# Extract data
extractData() {
	# Question 4
	echo "Processing Data From $1"
	echo "===================================="
	echo "Year,Month,Day,Hour,TempS1,TempS2,TempS3,TempS4,TempS5,WindS1,WindS2,WindS3,WinDir"
	# Stripping the file to remove unwanted bits	
	grep 'observation line' $1 | sed -e 's/observation line/ /g' -e 's/\[data log flushed]/ /g' -e 's/MISSED SYNC STEP/Missing/g' -e 's/NOINF/Missing/g' | awk ' BEGIN { OFS="," } { 
	# Defining the date and hour
	year=substr($1,0,4)
	month=substr($1,6,2)
	day=substr($1,9,2)
	hour=substr($2,0,2)
	
	# Checking the temperatures, assuming that the first line does not have missing records
	if ($3 != "Missing") {
		TempS1=$3
	}
	if ($4 != "Missing") {
		TempS2=$4
	}
	if ($5 != "Missing") {
		TempS3=$5
	}
	if ($6 != "Missing") {
		TempS4=$6
	}
	if ($7 != "Missing") {
		TempS5=$7
	}
	
	# Defining the wind sensors
	WindS1=$8
	WindS2=$9
	WindS3=$10

	# Checking for wind direction
	if ($NF == 0) {
		WinDir="N"
	} else if ($NF == 1) {
		WinDir="NE"
	} else if ($NF == 2) {
		WinDir="E"
	} else if ($NF == 3) {
		WinDir="SE"
	} else if ($NF == 4) {
		WinDir="S"
	} else if ($NF == 5) {
		WinDir="SW"
	} else if ($NF == 6) {
		WinDir="W"
	} else if ($NF == 7) {
		WinDir="NW"
	}

	# Output the wanted information
	print year, month, day, hour, TempS1, TempS2, TempS3, TempS4, TempS5, WindS1, WindS2, WindS3, WinDir
	}'

	# Question 5
	echo "===================================="
	echo "Observation Summary"
	echo "Year,Month,Day,Hour,MaxTemp,MinTemp,MaxWS,MinWS"
	# Stripping unwanted lines and fields
	grep 'observation line' $1 | sed -e 's/observation line/ /g' -e 's/\[data log flushed]/ /g' -e 's/MISSED SYNC STEP/Missing/g' -e 's/NOINF/Missing/g' | awk ' BEGIN { OFS="," } {
	# Defining the date and hour
	year=substr($1,0,4)
	month=substr($1,6,2)
	day=substr($1,9,2)
	hour=substr($2,0,2)

	# Finding the first temperature that is not missing
	for (i=3; i<=7; i++){
		if ($i != "Missing") {
			MaxTemp=$i
			MinTemp=$i
			# Compare it to all other temperature to find the max and min
			for (j=i; j<=7; j++) {
				if ($j > MaxTemp && $j != "Missing") {
					MaxTemp=$j
				}
				if ($j < MinTemp && $j != "Missing") {
					MinTemp=$j
				}
			}
			break
		}
	}

	# Find the max and min wind speed
	MaxWS=$8
	MinWS=$8
	for (i=9; i<=10; i++) {
		if ($i > MaxWS) {
			MaxWS=$i
		}
		if ($i < MinWS) {
			MinWS=$i
		}
	}
	
	# Output the data
	print year, month, day, hour, MaxTemp, MinTemp, MaxWS, MinWS
	}'
}

# Find the file that matches the pattern and run extractData
for file in $(find $1 -name "weather_info_*.data")
do
	extractData $file
done

# Question 6
# Create or overwrite the file, and append the first five lines
echo "<HTML>" > sensorstats.html
echo "<BODY>" >> sensorstats.html
echo "<H2>Sensor error statistics</H2>" >> sensorstats.html
echo "<TABLE>" >> sensorstats.html
echo "<TR><TH>Year</TH><TH>Month</TH><TH>Day</TH><TH>TempS1</TH><TH>TempS2</TH><TH>TempS3</TH><TH>TempS4</TH><TH>TempS5</TH><TH>Total</TH><TR>" >> sensorstats.html

# Loop through the files again to extract the missing sensors
for file in $(find $1 -name "weather_info_*.data")
do
	grep 'observation line' $file | sed -e 's/observation line/ /g' -e 's/\[data log flushed]/ /g' -e 's/MISSED SYNC STEP/Missing/g' -e 's/NOINF/Missing/g' | awk 'BEGIN {
	TempS1=0
	TempS2=0
	TempS3=0
	TempS4=0
	TempS5=0
	Total=0
	}
	{	
	year=substr($1,0,4)
	month=substr($1,6,2)
	day=substr($1,9,2)

	if ($3 == "Missing") {
		TempS1++
		Total++
	}
	if ($4 == "Missing") {
		TempS2++
		Total++
	}
	if ($5 == "Missing") {
		TempS3++
		Total++
	}
	if ($6 == "Missing") {
		TempS4++
		Total++
	}
	if ($7 == "Missing") {
		TempS5++
		Total++
	}

	}
	# Output only at the end so that each file, and send the output to sort, sed, and append to the file
	END {print year, month, day, TempS1, TempS2, TempS3, TempS4, TempS5, Total}
	'
done | sort -k9,9nr -k1,2n | sed -e 's/^/<TR><TD>/' -e 's/ /<\/TD><TD>/g' -e 's/$/<\/TD><\/TD>/' >> sensorstats.html

# Append the last three lines to the file 
echo "</TABLE>" >> sensorstats.html
echo "</BODY>" >> sensorstats.html
echo "</HTML>" >> sensorstats.html
# DONEEEE
