#!/usr/bin/bash

clear

# Setup project directory
export project_dir="/home/eoex/Documents/Rx/DOJO/TEMP"
export script_dir="/home/eoex/Documents/Rx/DOJO/scripts"


# environment variables
export main="main"
export prod="production"
export uat="uat"
export release="release"
export staging="staging"

# setup the remote repo (Github)
export remote="$(git remote)"


# local remote repo branches
export remote_main="$remote/$main"
export remote_prod="$remote/$prod"
export remote_uat="$remote/$uat"
export remote_release="$remote/$release"
export remote_staging="$remote/$staging"

# local tracking branches
export local_main="local-$main"
export local_prod="local-$prod"
export local_uat="local-$uat"
export local_release="local-$release"
export local_staging="local-$staging"

# local development branches
export feature_branch="dev-feature"
export fix_branch="dev-fix"
export stash_branch="dev-stash"
export patch_branch="dev-patch"





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
export source_dir="/home/eoex/Documents/Rx/dev-src"
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


$current_branch=$target_branch
echo "Current Branch: $current_branch"
echo
echo

git commit -m "$commit_ref $commit_dom $commit_US $commit_job $commit_stamp"
export current_commit_hash=$(git rev-parse --short HEAD)
echo "Current commit HASH:	" $current_commit_hash


# Tag the latest development commit
git tag -a $us_code-$current_branch-v$version.$reference -m "$us_summary" $current_commit_hash
echo
echo "---------- END OF COMMIT  ------------"





# Check all tags created
echo
echo
echo "LIST Of TAGS"
git tag

# Move back into the local-main branch
echo
echo
echo "Moving to $local_main branch"
git checkout $local_main 

# Merge the last development branch onto local-main
echo
echo
echo "Merging last dev into local-main branch"
git merge $current_branch 		## NOTE: this should automatically update the remote repo because this branch is tracking remote/main

# Push latest changes from local-main to remote repo
echo
echo
echo "############ FINAL CHECK #######"
echo
echo "git fetch --all"
git fetch --all
echo
echo "git config pull.rebase false"
git config pull.rebase false
echo
echo "git pull remote-testlab"
git pull remote-testlab
echo
echo "git push $remote HEAD"
git push $remote HEAD
echo
echo



git log --pretty=format:"%h - %an, %ar : %s"
