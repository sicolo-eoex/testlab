#!/usr/bin/bash



##########
# SETUP:
# This script sets up git on your local machine
# Note: Please adapt to your environment
##########



# exportironment variables
export _user="$(id -u -n)"
export _uid="$(id -u)"
export GIT_USER_NAME="Sosthene Grosset-Janin"
export GIT_USER_EMAIL="sgrosset@gmail.com"
export GIT_PROJECT_FOLDER="$(pwd)"
export GIT_PROJECT_NAME="TestProj"


# Global configurations
git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_EMAIL


# Check global configurations
git config --list
# Edit global configurations manually
cat ~/.gitconfig


# Initialise the project folder
cd $GIT_PROJECT_FOLDER
git init



##########################
## OUTPUT
##########################
clear
echo
echo
echo "Welcome to this Rx (Release Management) script"
echo "----------------------------------------------"
echo
echo "User name: " $_user
echo "User ID: "   $_uid
echo
echo
echo "-----------------------------------------------"
echo "Git Project: "               $GIT_PROJECT_NAME
echo "Git Project directory: "     $GIT_PROJECT_FOLDER
echo "Git User name: "             $GIT_USER_NAME
echo "Git User email: "            $GIT_USER_EMAIL
echo 
echo "Project directory view: "
ls -a
