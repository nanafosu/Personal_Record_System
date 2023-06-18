#!/bin/bash

while true; do
    clear
    echo "Personal Record Management System"
    echo "---------------------------------"
    echo "1. Add a new record"
    echo "2. Edit existing records"
    echo "3. Search for specific records"
    echo "4. Generate reports"
    echo "5. Exit"
    echo

    read -p "Enter your choice: " choice
    echo

    case $choice in
        1)
            # Add a new record functionality

    	    echo "Add a New Record"
    	    echo "----------------"
		
			read -p "Enter the surname name: " surname
			read -p "Enter other name(s): " other_names
            read -p "Enter the age: " age
    	    read -p "Enter the address: " address
			full_name="$surname $other_names"
    	    # Append the record to the file

    	    echo "$full_name,$age,$address" >> records.csv
	
			echo "Record added successfully."

            ;;
        2)
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
	    
            ;;
        3)
			# Search for specific records functionality
			echo "Search for Specific Records"
			echo "---------------------------"

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
			fi
			;;
        4)
			# Generate reports functionality
			echo "Generate Reports"
			echo "----------------"

			echo "1. All Records"
			echo "2. Records by Age"
			echo "3. Records by Address"
			echo "4. Exit"

			read -p "Enter your choice: " report_choice

			case $report_choice in
				1)
					echo "All Records:"
					echo "-------------"
					cat records.csv
					;;
				2)
					echo "Records by Age:"
					echo "---------------"
					echo "Enter the age range:"
					read -p "From: " age_from
					read -p "To: " age_to
					awk -F',' -v age_from="$age_from" -v age_to="$age_to" '$2 >= age_from && $2 <= age_to' records.csv
					;;
				3)
					echo "Records by Address:"
					echo "-------------------"
					read -p "Enter the address to search for: " search_address
					grep -i "$search_address" records.csv
					;;
				4)
					echo "Exiting report generation."
					;;
				*)
					echo "Invalid choice. Please try again."
					;;
			esac
			;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    read -p "Press Enter to continue..."
done
