# Navigate to the root of your project directory
# cd 

# Loop through all directories in the current directory, excluding the dist/ folder
for d in */ ; do
    # Navigate to the directory
    cd $d
    # If the directory has a package.json file, run npm install and npm run build
    if [ -f "package.json" ]; then
        npm install
        npm run build
    fi
    # Navigate back to the root of the project directory
    cd ..
done

# Create a new folder for the deployed files, and clear it if it exists
rm -rf docs
mkdir -p docs

# Loop through all directories in the current directory again, excluding the dist/ folder
for d in $(find . -maxdepth 1 -type d ! -path "./docs"); do
    # If .git/ is in the directory name, delete it
    if [[ $d == *".git"* ]]; then
        d=${d/.git/}
    fi
  # Move the dist/ folder from the current directory into the deployed/ folder
  # But first rename the dist/ folder to the name of the current directory
    mv $d/dist docs/$(basename $d)
    # Find and replace all references to ="/ with ="./
    find docs/$(basename $d) -type f -name '*.html' -exec sed -i '' 's/=\"\//=\"\.\//g' {} +
    # Add .nojekyll to bypass Jekyll processing
    echo > docs/$(basename $d)/.nojekyll
done

# # Add the deployed/ folder to Git and commit the changes
# git checkout -B gh-pages
git add .
git commit -m "Adding deployed files"

# # Push the changes to your GitHub repository
git push origin master

