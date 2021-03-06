#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to Github...\033[0m\n"

# Build the project
hugo -D -t diary # or `hugo -D` if no theme is specified

# Go To Public folder
cd ../public

# Add changes to git
git add .

# Commit changes
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
    msg="$*"
fi
git commit -m "$msg"

# Push source and build repos
git push -u --all
