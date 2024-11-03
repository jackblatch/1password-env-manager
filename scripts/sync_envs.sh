#!/bin/bash

# Initialize variables
personal_item_name="$OP_PERSONAL_ENV_API_VARS" # Specifiy the personal item name to load your own envs in
overwrite=false
output_preference="references" # Pass in -v for the values
vault="envs" # Specify the vault name
section="local-development" # Specify the section name of the values within a 1Password item
target_file=".env"

# Parse command-line options using getopts
while getopts "i:ov" flag; do
  case "${flag}" in
    i) personal_item_name="${OPTARG}" ;;  # Capture the argument provided with -i (item name)
    o) overwrite=true ;;                  # If -o is provided, set overwrite to true
    v) output_preference="values" ;;      # If -v is provided, set values to "values"
    *) echo "Usage: $0 [-i personal_item_name] [-o] [-v]"
       exit 1 ;;
  esac
done

# Function to run the command with passed values and append or overwrite $target_file
run_command() {
  local item_name=$1
  local vault_name=$2
  local section_name=$3
  local output_format=$4

  ./get_envs.sh --item-name "$item_name" --vault-name "$vault_name" --section-name "$section_name" --output-preference "$output_format" >> $target_file
}

# Run the command with the first set of values
if [ "$overwrite" = true ]; then
  echo "# GLOBAL ENVS" > $target_file
else 
  echo "# GLOBAL ENVS" >> $target_file
fi
# Replace 'global-envs' with the item name to load the global envs
run_command "global-envs" "$vault" "$section" "$output_preference"
echo "Global envs of environment variables appended"


# Run the command with a second set of values
echo "# APP ENVS" >> $target_file
# Replace 'app-envs' with the item name to load the app envs
run_command "app-envs" "$vault" "$section" "$output_preference"
echo "APP envs of environment variables appended"

# Run the command with the personal_item_name passed to the script
if [ -n "$personal_item_name" ]; then
  echo "# PERSONAL ENVS" >> $target_file
  run_command "$personal_item_name" "$vault" "$section" "$output_preference"
  echo "Personal envs of environment variables appended"
else
  echo "No personal item name provided"
fi

