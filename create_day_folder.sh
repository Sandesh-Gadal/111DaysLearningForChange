#!/bin/bash

# Prompt for the day number
read -p "Enter the day number: " DAY

# Format folder name as Day001, Day045, etc.
FOLDER_NAME=$(printf "Day%03d" $DAY)

# Check if folder already exists
if [ -d "$FOLDER_NAME" ]; then
    echo "❗ $FOLDER_NAME already exists. Choose another day or delete the folder."
    exit 1
fi

# Create the folder structure
mkdir -p "$FOLDER_NAME/resources"
touch "$FOLDER_NAME/notes.md"
touch "$FOLDER_NAME/linkedin-post.txt"

echo "✅ $FOLDER_NAME created successfully with:"
echo "   - notes.md"
echo "   - linkedin-post.txt"
echo "   - resources/ (folder)"
