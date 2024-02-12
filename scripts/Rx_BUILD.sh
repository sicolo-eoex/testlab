#!/usr/bin/bash

clear

# Setup project directory
export project_dir="/home/eoex/Documents/Rx/DOJO/TEMP"
export script_dir="/home/eoex/Documents/Rx/DOJO/scripts"

cd $project_dir
chmod u+x $script_dir/*sh

# Launch git init setup
 $script_dir/./Rx_setup.sh 

# Create project branches
$script_dir/./Rx_branches.sh 

# Check all branches status
git branch -vv
 
# Check local dev branches
git checkout dev-feature 
git checkout dev-fix
git checkout dev-stash
git checkout dev-patch

# Check all branches status
git branch -vv

# Fetch latest updates updates from remote repo
git fetch --all

# Mode to local main/master branch
git checkout local-main 

# Set local main/master branch as "tracking branch" looking up to  remote/main branch
git branch --set-upstream-to=remote-testlab/main local-main

# Fetch and Merge latest updates from the remote repo into local-main branch
git pull remote-testlab local-main

# Check all branches status
git branch -vv


######################################
### DEVELOPMENT                    ###
######################################

# move to target branch (feature / fix / stash / patch)
# local development branches
export feature_branch="dev-feature"
export fix_branch="dev-fix"
export stash_branch="dev-stash"
export patch_branch="dev-patch"

echo
echo
echo
echo "##############################"
echo "# BUILD MENU"
echo "##############################"
echo
echo
echo "What is the development objective? "
echo "New Feature					[1]"
echo "Bug Fix						[2]"
echo "New Savepoint (stash)		[3]"
echo "New Patch					[4]"
echo 
read -p "choose an option: " input

if [ $input == 1 ]
then
        export target_branch=$feature_branch
	
	echo "Make your development feature changes..."
	git checkout $target_branch

elif [ $input == 2 ];then
        export target_branch=$fix_branch

	echo "Make your development fix changes..."
	git checkout $target_branch

elif [ $input == 3 ];then
        export target_branch=$stash_branch

	echo "Creating a Savepoint (stash) for your current work..."
	git checkout $target_branch

elif [ $input == 4 ];then
        export target_branch=$patch_branch

	echo "Creating a new Patch..."
	git checkout $target_branch

fi






# Make development changes ....
export source_dir="/home/eoex/Documents/Rx/DOJO/dev-src"
export target_dir="/home/eoex/Documents/Rx/DOJO/TEMP/src"


echo 
echo
echo "--------- DEVELOPMENT CHANGES --------------"
read -p "Make your development changes and press [ENTER]: " input
cp $source_dir/* $target_dir
echo "--------- END OF DEVELOPMENT --------------"
echo
echo





# Stage development changes
echo
echo "---------- STAGING CHANGES ---------------------"
git add .
echo "---------- END OF STAGING ---------------------"
echo
echo

# Commit development changes
echo
echo
echo "---------- COMMIT CHANGES ------------"

read -p "Enter commit reference: 	" reference
read -p "Enter commit version:		" version
read -p "Enter User Story code:		" us_code
read -p "Enter User Story summary:	" us_summary

export commit_ref="Ref: [$reference]"
export commit_dom="Dom: $current_branch"
export commit_US="US: $us_code"
export commit_job="Job: $us_summary"
export commit_stamp="Stamp: $(date)"

echo "Current Branch: $current_branch"
git commit -m "$commit_ref $commit_dom $commit_US $commit_job $commit_stamp"
export current_commit_hash=$(git rev-parse --short HEAD)
echo "Current commit HASH:	" $current_commit_hash


# Tag the latest development commit
git tag -a $us_code-$current_branch-v$version.$reference -m "$us_summary" $current_commit_hash
echo
echo "---------- END OF COMMIT  ------------"





# Check all tags created
git tag

# Move back into the local-main branch
git checkout local-main 

# Merge the last development branch onto local-main
git merge dev-feature 		## NOTE: this should automatically update the remote repo because this branch is tracking remote/main

# Push latest changes from local-main to remote repo
git push remote-testlab HEAD

git log --pretty=format:"%h - %an, %ar : %s"

cat ../build.log
