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


# Fetch remote repo branches
git fetch $remote
git fetch --all
git pull $remote
sleep 2	# wait before clearing the screen


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



export sample_file="testfile.txt"
export current_branch="$(git rev-parse --abbrev-ref HEAD)"
echo
echo
echo
echo "############ TEST RUN #################"
echo "#######################################"

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
git add .

echo
echo
echo "---------- STASH CHANGES (SAVEPOINT) ---------"

echo
echo
echo "---------- COMMIT CHANGES ------------"
echo "Current Branch: $current_branch"
git commit -m "Ref: [000] Dom: $current_branch US: XYZ-1 Job: Create sample data Stamp: $(date)"

echo
echo
echo "--------- MERGE CHANGES TO local-main BRANCH ------------"
previous_branch=$current_branch
current_branch=$local_main

echo "Previous working branch:	"$previous_branch
echo "Current working branch:	"$current_branch

git checkout $current_branch
git merge $previous_branch


echo
echo
echo
echo "##############################"
echo "# Pre-build setup"
echo "##############################"
echo
echo
echo "What is the development objective? "
echo "New Feature 		[1]"
echo "Bug Fix			[2]"
echo "New Savepoint (stash)	[3]"
echo "New Patch			[4]"
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


##########################
## OUTPUT
##########################
clear
echo
echo
echo "Rx Branching strategy"
echo "----------------------------------------------"
echo
echo "Local Environment"
echo "Main:		" $local_main
echo "Production:	" $local_prod
echo "UAT:		" $local_uat
echo "Release:		" $local_release
echo "Staging:		" $local_staging
echo
echo
echo "-----------------------------------------------"
echo
echo "Remote Environment"
echo "Main:             " $remote_main
echo "Production:       " $remote_prod
echo "UAT:              " $remote_uat
echo "Release:          " $remote_release
echo "Staging:          " $remote_staging
echo
echo
echo "Remote Repo: "
git remote -v
git branch -a
git branch -vv
