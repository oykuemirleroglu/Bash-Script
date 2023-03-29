#!/bin/bash


search_and_copy() {
    keyword=$1
    target_directory=$2
    found_files=0

    mkdir -p Found

    cd "$target_directory"
    for file in *; do
        if [[ -f $file ]]; then
            if grep -q -i "$keyword" "$file"; then
                cp "$file" "../Found/found_$file"
                found_files=1
            fi
        fi
    done
    cd ..

    if [[ $found_files -eq 1 ]]; then
        echo "Files were copied to the Found directory!"
        echo "Files in the Found directory:"
        ls Found
        display_modification_details
    else
        echo "Keyword not found in files!"
    fi
}

display_modification_details() {
    cd Found
    touch modification_details.txt
    echo "" > modification_details.txt

    for file in found_*; do
        if [[ -f $file ]]; then
            modification_details=$(stat -c "File %n was modified by %U on %y" "$file")
            echo "$modification_details"
            echo "$modification_details" >> modification_details.txt
        fi
    done

    cd ..
}


read -p "Enter the directory to search in: " target_directory
read -p "Enter the keyword to search for: " keyword

search_and_copy "$keyword" "$target_directory"

