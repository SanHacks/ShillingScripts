#!/bin/bash

# Default MySQL port
port=3306

# Prompt the user for MySQL host, username, and password
read -p "Enter MySQL host [localhost]: " host
host=${host:-localhost}

# Prompt for the database name
read -p "Enter the database name: " dbname

read -p "Enter MySQL port [3306:default]:(leave blank to use default) " custom_port
port=${custom_port:-$port}

read -p "Enter MySQL username: " username
read -s -p "Enter MySQL password: " password
echo


# Prompt for tables to skip
read -p "Enter tables to skip (comma-separated, or leave empty): " tables_to_skip

# Generate a filename based on the database name
filename="${dbname}_dump_$(date +'%Y%m%d%H%M%S').sql"

# Build the skip-tables argument
skip_tables_arg=""
if [ -n "$tables_to_skip" ]; then
    IFS=',' read -ra tables <<< "$tables_to_skip"
    for table in "${tables[@]}"; do
        skip_tables_arg+="--ignore-table=${dbname}.${table} "
    done
fi

# Use mysqldump with specified options to create a dump and save it with the generated filename
mysqldump -h "$host" -P "$port" -u "$username" -p"$password" "$dbname" $skip_tables_arg > "$filename" -vvv

# Check the exit status of mysqldump
if [ $? -eq 0 ]; then
    echo "Dump saved to $filename"
else
    echo "Error creating the dump. Check your credentials and try again."
fi
