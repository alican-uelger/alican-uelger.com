#!/bin/bash

REPOS_URL="https://api.github.com/users/$GITHUB_USER/repos"

response=$(curl -s $REPOS_URL)
echo "$response"
repos=$(echo "$response" | jq -r '.[] | .name')

result='+++
title = "Projects (GitHub)"
slug = "projects"
+++

'

for repo in $repos; do
    repo_info=$(curl -s "https://api.github.com/repos/$GITHUB_USER/$repo")

    title=$(echo $repo_info | jq -r '.name')
    description=$(echo $repo_info | jq -r '.description // "No description available."')  # Fallback for empty description
    created_at=$(echo $repo_info | jq -r '.created_at')

    markdown="---
title: \"$title\"
date: $created_at
---

# $title

$description

"
    result="$result$markdown"
    echo "Created Markdown for repository '$repo'"
done

echo "$result" > "./content/projects.md"
