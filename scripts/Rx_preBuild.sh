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


git checkout $target_branch


#export sample_file="testfile.txt"
export sample_file="../src/MyClass.java"
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
echo " String firstString = "sos";
		}
	 " >> $sample_file
echo "Tail contents of the data file $sample_file:"
echo
tail $sample_file

echo
echo
echo "---------- STAGING CHANGES ---------------------"
git add .

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
git tag -a $current_branch-v$version.$reference-$us_code -m "$us_summary" $current_commit_hash

echo
echo
echo "--------- MERGE CHANGES TO local-main BRANCH ------------"
previous_branch=$current_branch
current_branch=$local_main

echo "Previous working branch:	"$previous_branch
echo "Current working branch:	"$current_branch


git checkout $current_branch

# git commit -a -m "$commit_ref $commit_dom $commit_US $commit_job $commit_stamp"

git pull $remote main --allow-unrelated-histories
git merge $previous_branch
git push
git push remote-testlab HEAD


export current_commit_hash=$(git rev-parse --short HEAD)
echo "Current commit HASH:	" $current_commit_hash
export merge_summary="Job: MERGE $previous_branch TO $current_branch"
git tag -a $previous_branch-MERGETO-$current_branch-v$version.$reference-$us_code -m "$us_summary" $current_commit_hash



echo
echo
echo "GIT COMMIT HISTORY"
git log --pretty=format:"%h - %an, %ar : %s"
