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


# Create local development branches
export feature_branch="dev-feature"
export fix_branch="dev-fix"
export stash_branch="dev-stash"
export patch_branch="dev-patch"

git checkout -b $feature_branch
git checkout -b $fix_branch
git checkout -b $stash_branch
git checkout -b $patch_branch



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




