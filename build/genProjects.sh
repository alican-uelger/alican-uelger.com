#!/bin/bash

REPOS_URL="https://api.github.com/users/$GITHUB_USER/repos"

response=$(curl -s $REPOS_URL)
repos=$(echo "$response" | jq -r '.[] | {name: .name, stars: .stargazers_count, created_at: .created_at} | @base64')

result='+++
title = "Projects (GitHub)"
slug = "projects"
+++

'

# Decode base64 and sort by stars and created_at
sorted_repos=$(for repo in $repos; do
    echo $repo | base64 --decode
done | jq -s 'sort_by(.stars, .created_at) | reverse | .[]')

for repo in $(echo "$sorted_repos" | jq -r '.name'); do
    repo_info=$(curl -s "https://api.github.com/repos/$GITHUB_USER/$repo")

    title=$(echo $repo_info | jq -r '.name')
    description=$(echo $repo_info | jq -r '.description // "No description available."')
    created_at=$(echo $repo_info | jq -r '.created_at')

    markdown="# [$title](https://github.com/$GITHUB_USER/$repo)

    $description

"
    result="$result$markdown"
    echo "Created Markdown for repository '$repo'"
done

echo "$result" > "./content/projects.md"