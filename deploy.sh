#!/usr/bin/env sh

# abort on errors
set -e

# create a build folder and clear it if it exists
rm -rf dist
mkdir -p dist

# cd into each directory and run npm run build, if it has a package.json
for dir in */; do
  if [ -f "$dir/package.json" ]; then
    cd $dir
    npm install
    npm run build
    # Delete all contents other than the dist folder
    # rm -rf `ls | grep -v dist`
    # Move the contents of the dist folder to the root of this directory
    # mv dist/* .
    # Replace any reference of /assets/ with ./assets/
    find . -type f -name '*.html' -exec sed -i '' 's/\/assets\//\.\/assets\//g' {} +
    # Add .nojekyll to bypass Jekyll processing
    echo > .nojekyll
    # Delete all files and folders that are not .nojekyll, index.html, or assets/
    # rm -rf `ls -a | grep -v .nojekyll | grep -v index.html | grep -v assets`
    # rename the dist folder to the name of the directory
    mv dist $dir
    # Move the contents of the dist folder to the root dist folder
    mv $dir ../dist
  fi
done

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git checkout -B master
git add -A
git commit -m 'Deploy'

# if you are deploying to https://<USERNAME>.github.io
# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git main

# if you are deploying to https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:connorrothschild/better-data-visualizations-with-svelte.git

cd -