#!/bin/bash

# Specify the file to read in
input_file="passes.ignore"

# Loop through each line in the file
while read line; do

  # Extract the two items from the line
  username=$(echo "$line" | cut -d$'\t' -f 1)
  password=$(echo "$line" | cut -d$'\t' -f 2)

  htpasswd -b -m htpasswd $username $password

done < "$input_file"
