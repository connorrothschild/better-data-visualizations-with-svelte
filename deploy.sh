#!/usr/bin/env sh

# abort on errors
set -e

git init
git checkout -B master

# cd into each directory and run npm run build, if it has a package.json
for dir in */; do
  if [ -f "$dir/package.json" ]; then
    cd $dir
    npm install
    npm run build
    # Delete all contents other than the dist folder
    rm -rf `ls | grep -v dist`
    # Move the contents of the dist folder to the root of this directory
    mv dist/* .
    # Replace any reference of /assets/ with ./assets/
    find . -type f -name '*.html' -exec sed -i '' 's/\/assets\//\.\/assets\//g' {} +
    # Add .nojekyll to bypass Jekyll processing
    echo > .nojekyll
    # Delete all files and folders that are not .nojekyll, index.html, or assets/
    rm -rf `ls -a | grep -v .nojekyll | grep -v index.html | grep -v assets`
  fi
done

git add -A
git commit -m "Deploy: $(date +%F)"

# if you are deploying to https://<USERNAME>.github.io
# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git master

# if you are deploying to https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:connorrothschild/better-data-visualizations-with-svelte.git master:gh-pages

cd -
git checkout .