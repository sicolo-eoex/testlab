#!/usr/bin/bash



##########
# SETUP:
# This script creates local and remote branches for your git project
# Note: Please note that the local branches are "tracking branches" of their
#       equivalent remote repo branches
##########



# environment variables
export main="main"
export prod="production"
export uat="uat"
export release="release"
export staging="staging"

# setup the remote repo (Github)
git remote add remote-testlab https://github.com/sicolo-eoex/testlab.git
export remote="$(git remote)"


# Fetch remote repo branches
git fetch $remote
git fetch --all

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


# Create local "Tracking branches" from remote repo branches
git checkout --track -b $local_main $remote_main
# git branch --set-upstream-to=remote-testlab/main local-main
# git branch --set-upstream-to=$remote_main $local_main

git checkout --track -b $local_prod $remote_prod
# git branch --set-upstream-to=remote-testlab/production local-production
# git branch --set-upstream-to=$remote_prod $local_prod

git checkout --track -b $local_uat $remote_uat
# git branch --set-upstream-to=remote-testlab/uat local-uat
# git branch --set-upstream-to=$remote_uat $local_uat

git checkout --track -b $local_release $remote_release
# git branch --set-upstream-to=remote-testlab/release local-release
# git branch --set-upstream-to=$remote_release $local_release

git checkout --track -b $local_staging $remote_staging
# git branch --set-upstream-to=remote-testlab/staging local-staging
# git branch --set-upstream-to=$remote_staging $local_staging



# Create local development branches
export feature_branch="dev-feature"
export fix_branch="dev-fix"
export stash_branch="dev-stash"
export patch_branch="dev-patch"

git checkout -b $feature_branch
git checkout -b $fix_branch
git checkout -b $stash_branch
git checkout -b $patch_branch


##########################
## OUTPUT
##########################
clear
echo
echo
echo "Rx Branching strategy"
echo "----------------------------------------------"
echo
echo "Local Tracking Branches"
echo "Main:		" $local_main
echo "Production:	" $local_prod
echo "UAT:		" $local_uat
echo "Release:		" $local_release
echo "Staging:		" $local_staging
echo
echo
echo "-----------------------------------------------"
echo
echo "Remote Repo Branches"
echo "Main:             " $remote_main
echo "Production:       " $remote_prod
echo "UAT:              " $remote_uat
echo "Release:          " $remote_release
echo "Staging:          " $remote_staging
echo
echo
echo "-------------------------------------------------"
echo
echo "Local Development Branches"
echo "Feature Branch:	" $feature_branch
echo "Fix Branch:	" $fix_branch
echo "Stash Branch:	" $stash_branch
echo "Patch Branch:	" $patch_branch


echo
echo "Remote Repo: "
git remote -v
git branch -a
git branch -vv
