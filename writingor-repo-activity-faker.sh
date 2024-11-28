#!/bin/bash

# Date start
first_commit_date=$(date -d "2017-01-09 09:00:00" +%s)
# Date end
last_commit_date=$(date -d "2019-12-28 18:00:00" +%s) 
# Nowadays
current_date=$(date +"%Y-%m-%d %H:%M:%S")

# Working hours
generate_random_time() {
    hour=$((RANDOM % 9 + 9)) # Hours from 09 to 17
    minute=$((RANDOM % 60))  # Minutes from 00 to 59
    second=$((RANDOM % 60))  # Seconds from 00 to 59
    printf "%02d:%02d:%02d\n" $hour $minute $second
}

# Output directory
output_dir="dates"
mkdir -p "$output_dir"

# Days Loop
timestamp=$first_commit_date

while [ $timestamp -le $last_commit_date ]; do
    # Timestamp to date
    date=$(date -d @$timestamp +"%Y-%m-%d")
    day_of_week=$(date -d @$timestamp +"%u")

    # Skip weekends -lt 6
    if [ $day_of_week -lt 6 ]; then
        chance_create_commit_in_current_day=23 # 23%
        
        if [ $((RANDOM % 100)) -lt $chance_create_commit_in_current_day ]; then
            amount_of_commits=$((RANDOM % 16 + 1))

            # Commits Loop
            for i in $(seq 1 $amount_of_commits); do
                # Generate date
                random_time=$(generate_random_time)
                random_number=$((RANDOM % 10000))
                random_date="$date $random_time"

                # Save the file
                file_path="$output_dir/${timestamp}_${i}_${random_number}.txt"
                echo $random_date > $file_path

                # Add commit
                export GIT_COMMITTER_DATE=$random_date
                export GIT_AUTHOR_DATE=$random_date

                git add "$file_path"
                git commit -am "Create fake activity on $random_date."
            done
        fi
    fi

    # to next day
    timestamp=$(($timestamp + 86400)) # 86400 seconds in a day
done

# Reset DATE
export GIT_COMMITTER_DATE=$current_date
export GIT_AUTHOR_DATE=$current_date
