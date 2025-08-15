#!/bin/bash

# -------------------------------
# Step 1: Create Day folder
# -------------------------------
read -p "Enter the day number: " DAY
FOLDER_NAME=$(printf "Day%03d" $DAY)

if [ -d "$FOLDER_NAME" ]; then
    echo "❗ $FOLDER_NAME already exists. Choose another day or delete the folder."
    exit 1
fi

mkdir -p "$FOLDER_NAME/resources"
touch "$FOLDER_NAME/notes.md"
touch "$FOLDER_NAME/linkedin-post.txt"
echo "✅ $FOLDER_NAME created successfully with notes.md, linkedin-post.txt, resources/"

# -------------------------------
# Step 2: Get LinkedIn post
# -------------------------------
echo "Paste the LinkedIn post content here (Ctrl+D to finish):"
POST_CONTENT=$(</dev/stdin)

# -------------------------------
# Step 3: Analyze with AI
# -------------------------------
ANALYSIS=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer " \
  -d "{
    \"model\": \"gpt-4o-mini\",
    \"messages\": [
      {\"role\": \"system\", \"content\": \"You are an assistant that analyzes LinkedIn posts from a daily coding learning journey.\"},
      {\"role\": \"user\", \"content\": \"Analyze this post: $POST_CONTENT. Return only this format:
Commit: <short commit message max 50 chars>
Topics: <comma-separated topics>
Keywords: <comma-separated keywords>
Summary: <2 sentence summary>\"}
    ]
  }" | jq -r '.choices[0].message.content')

echo -e "\n--- AI Analysis ---\n$ANALYSIS"

# -------------------------------
# Step 4: Update notes.md
# -------------------------------
echo -e "\n## AI Analysis\n$ANALYSIS" >> "$FOLDER_NAME/notes.md"

# -------------------------------
# Step 5: Update summary.md
# -------------------------------
SUMMARY_FILE="summary.md"
LINK="*(No link yet)*"

if [ -f "$FOLDER_NAME/linkedin-post.txt" ]; then
  LINK=$(head -n 1 "$FOLDER_NAME/linkedin-post.txt")
fi

if ! grep -q "| $FOLDER_NAME |" "$SUMMARY_FILE"; then
  echo "| $FOLDER_NAME | [$FOLDER_NAME Post]($LINK) | [$FOLDER_NAME Notes]($FOLDER_NAME/notes.md) | [$FOLDER_NAME Resources]($FOLDER_NAME/resources/) |" >> "$SUMMARY_FILE"
  echo "✅ $FOLDER_NAME added to summary.md"
else
  echo "Day $FOLDER_NAME already exists in summary.md. Skipping."
fi

# -------------------------------
# Step 6: Git commit & push
# -------------------------------
COMMIT_MSG=$(echo "$ANALYSIS" | grep '^Commit:' | sed 's/Commit: //')

if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="Update $FOLDER_NAME notes"
fi

git add "$FOLDER_NAME" "$SUMMARY_FILE"
git commit -m "$COMMIT_MSG"
git push

echo "✅ $FOLDER_NAME updated & pushed with AI-generated commit message!"
