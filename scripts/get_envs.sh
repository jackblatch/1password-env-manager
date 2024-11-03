#!/bin/bash

# Default values
itemName=""
vaultName="envs"
sectionName="local-development"
outputPreference="references"

# Parse flags
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --item-name) itemName="$2"; shift ;;
    --vault-name) vaultName="$2"; shift ;;
    --section-name) sectionName="$2"; shift ;;
    --output-preference) outputPreference="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# Function to fetch item details
fetch_item_details() {
  pwCommand="op item get $itemName --vault $vaultName --format=json"

  # Fetch data using op command and process the result
  res=$(eval "$pwCommand")
  if [ $? -ne 0 ]; then
    echo "Oops, no results could be found matching those values. Please make sure your values are correct and try again."
    exit 1
  fi

  parsedData=$(echo "$res" | jq -c '.fields[]')
  hasEntry=false
  while IFS= read -r item; do
    section=$(echo "$item" | jq -r '.section.label')
    itemType=$(echo "$item" | jq -r '.type')

    if [[ "$section" == "$sectionName" && "$itemType" == "CONCEALED" ]]; then
      if ! $hasEntry; then
        hasEntry=true
      fi
      label=$(echo "$item" | jq -r '.label')
      if [[ "$outputPreference" == "values" ]]; then
        value=$(echo "$item" | jq -r '.value')
        echo "$label=$value"
      else
        reference=$(echo "$item" | jq -r '.reference')
        echo "$label=\"$reference\""
      fi
    fi
  done <<< "$parsedData"

  if ! $hasEntry; then
    echo "No items found. Please make sure your values are correct and try again."
    exit 1
  fi
}

# Main script execution
fetch_item_details

