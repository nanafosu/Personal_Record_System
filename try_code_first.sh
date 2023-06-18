#!/bin/bash


    # Edit existing records functionality
    echo "Edit Existing Records"
    echo "---------------------"

    read -p "Enter the name to search for: " search_name

    # Convert the search_name to lowercase
    search_name_lowercase=$(echo "$search_name" | tr '[:upper:]' '[:lower:]')

    # Search for records matching the search_name (case-insensitive)
    matching_records=$(grep -i "$search_name_lowercase" records.csv)

    if [ -z "$matching_records" ]; then
        echo "No records found matching the search name: $search_name"
    else
        echo "Matching records:"
        echo "$matching_records"

        read -p "Enter the record number to edit: " record_number

        # Validate the record number
        if ! [[ "$record_number" =~ ^[0-9]+$ ]]; then
            echo "Invalid record number. Please try again."
        elif (( record_number <= 0 || record_number > $(grep -c '^' records.csv) )); then
            echo "Record number out of range. Please try again."
        else
            # Retrieve the specific record from the file
            record=$(sed -n "${record_number}p" records.csv)

            # Extract the individual fields from the record
            old_full_name=$(echo "$record" | cut -d ',' -f 1)
            old_age=$(echo "$record" | cut -d ',' -f 2)
            old_address=$(echo "$record" | cut -d ',' -f 3)

            echo "Editing Record $record_number:"
            echo "Full Name: $old_full_name"
            echo "Age: $old_age"
            echo "Address: $old_address"

            # Prompt the user to enter the updated fields
            read -p "Enter the new full name: " new_full_name
            read -p "Enter the new age: " new_age
            read -p "Enter the new address: " new_address

            # Replace the old record with the updated record in the file
            sed -i "${record_number}s/$old_full_name,$old_age,$old_address/$new_full_name,$new_age,$new_address/" records.csv

            echo "Record $record_number updated successfully."
        fi
    fi
    