#!/bin/bash

SUMMARY_FILE="summary.md"

# Loop through all DayXXX folders
for folder in Day*/; do
  DAY_NAME="${folder%/}"  # e.g. Day001
  LINK_FILE="$folder/linkedin-post.txt"
  NOTES_FILE="$folder/notes.md"
  RESOURCES_FOLDER="$folder/resources"

  # Check if the day is already in the summary.md file
  if ! grep -q "| $DAY_NAME |" "$SUMMARY_FILE"; then
    if [ -f "$LINK_FILE" ]; then
      LINK=$(grep -Ei 'https://(www\.)?linkedin\.com' "$LINK_FILE" | head -n 1)

      # LinkedIn Post URL (if found)
      if [ -n "$LINK" ]; then
        LINK_POST="[$DAY_NAME Post]($LINK)"
      else
        LINK_POST="*(No link yet)*"
      fi

      # Notes link (if exists)
      if [ -f "$NOTES_FILE" ]; then
        LINK_NOTES="[$DAY_NAME Notes]($folder/notes.md)"
      else
        LINK_NOTES="*(No notes yet)*"
      fi

      # Resources folder link (if exists)
      if [ -d "$RESOURCES_FOLDER" ]; then
        LINK_RESOURCES="[$DAY_NAME Resources]($folder/resources/)"
      else
        LINK_RESOURCES="*(No resources yet)*"
      fi

      # Append this day's info to the summary
      echo "| $DAY_NAME | $LINK_POST | $LINK_NOTES | $LINK_RESOURCES |" >> "$SUMMARY_FILE"
      echo "✅ Day $DAY_NAME added to summary.md."
    fi
  else
    echo "Day $DAY_NAME already exists in summary.md. Skipping."
  fi
done
