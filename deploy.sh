#!/usr/bin/env sh

# Abort on errors
set -e

# Create a build folder and clear it if it exists
rm -rf docs
mkdir -p docs

for dir in **/**; do
    if [ -f "$dir/package.json" ]; then
      echo $dir
      cd $dir
      
      # Install dependencies
      npm install
      npm run build
     
      # Replace any reference of /assets/ with ./assets/
      find . -type f -name '*.html' -exec sed -i '' 's/\/assets\//\.\/assets\//g' {} +
      
      # Add .nojekyll to bypass Jekyll processing
      touch .nojekyll
        
      # Move the dist folder to the root docs/ folder, but prefix the output with code-<dir>/ and replace any / in the dir with -
      cd ../..
      pwd
      mv $dir/dist docs/${dir//\//-}

    fi
done

# Add and deploy
git checkout -B master
git add -A
git commit -m 'Deploy'

git push -f git@github.com:connorrothschild/better-data-visualizations-with-svelte.git

cd -
