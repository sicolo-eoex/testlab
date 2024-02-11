#!/usr/bin/bash



##########
# SETUP:
# This script creates a "savepoint" before the implementation of code changes
# setps:
#	Pull the latest changes from the remote repo branch to its equivalent local tracking branch
#	Create a "patch" of this savepoint
#	Create staging template
#	Create commit template
#	Create labels / tags
# Dependencies: This script depends on script Rx_branches.sh to have been executed successfully
##########



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

echo
echo
echo
echo "##############################"
echo "# Pre-build setup"
echo "##############################"
echo
echo
echo "What is the development objective? "
echo "New Feature					[1]"
echo "Bug Fix						[2]"
echo "New Savepoint (stash)			[3]"
echo "New Patch						[4]"
echo 
read -p "choose an option: " input

if [ $input == 1 ]
then
        export target_branch=$feature_branch
	
	echo "Make your development feature changes..."
	#git checkout $target_branch

elif [ $input == 2 ];then
        export target_branch=$fix_branch

	echo "Make your development fix changes..."
	#git checkout $target_branch

elif [ $input == 3 ];then
        export target_branch=$stash_branch

	echo "Creating a Savepoint (stash) for your current work..."
	#git checkout $target_branch

elif [ $input == 4 ];then
        export target_branch=$patch_branch

	echo "Creating a new Patch..."
	#git checkout $target_branch

fi


# Fetch remote repo branches
git fetch $remote
git fetch --all
git pull $remote
git checkout -f $target_branch



export sample_file="testfile.txt"
export current_branch="$(git rev-parse --abbrev-ref HEAD)"

echo
echo
echo
echo "##############################"
echo "# BUILD "
echo "##############################"
echo
echo

echo
echo
echo "----------- CREATE SAMPLE DATA/CODE -------- "
echo " --- ONE MORE LINE ADDED ---" >> $sample_file
echo "Tail contents of the data file $sample_file:"
echo
tail $sample_file

echo
echo
echo "---------- STAGING CHANGES ---------------------"
GIT_TRACE=1 git add .


