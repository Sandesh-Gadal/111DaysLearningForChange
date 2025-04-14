#!/bin/bash

# Check if inside a Git repository
if [ ! -d ".git" ]; then
  echo "❗ This is not a Git repository. Please run this script inside a Git-initialized folder."
  exit 1
fi

# Prompt for a commit message
read -p "Enter your commit message: " MESSAGE

# Add, commit, and push
git add .
git commit -m "$MESSAGE"
git push -u origin

# Optional success message
echo "✅ Changes pushed to GitHub successfully!"
