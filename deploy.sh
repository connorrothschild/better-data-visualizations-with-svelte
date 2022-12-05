#!/usr/bin/env sh

# Abort on errors
set -e

# Create a build folder and clear it if it exists
rm -rf docs
mkdir -p docs

# Loop through directories until a package.json file is found
# found=0
# while [ $found -eq 0 ]; do
  for dir in */; do
    if [ -f "$dir/package.json" ]; then
    #   found=1
      cd $dir
      # Install dependencies
      npm install
      npm run build
      # Replace any reference of /assets/ with ./assets/
      find . -type f -name '*.html' -exec sed -i '' 's/\/assets\//\.\/assets\//g' {} +
      # Add .nojekyll to bypass Jekyll processing
      touch .nojekyll
      # Rename the docs folder to the name of the directory
      mv docs $dir
      # Move the contents of the docs folder to the root docs folder
      mv $dir ../docs
      cd ..
    fi
  done
# done

# Add and deploy
git checkout -B master
git add -A
git commit -m 'Deploy'

git push -f git@github.com:connorrothschild/better-data-visualizations-with-svelte.git

cd -
