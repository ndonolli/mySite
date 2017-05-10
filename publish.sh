#!/bin/bash

# Script to automatically publish the site to the github pages repo

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # gets directory of this bash script
if [[ $PWD !=  $DIR ]]
then
  echo "Error: Current working directory is not the main website repo directory"
  exit 1
fi

hugo -t hemingway
cd "${PWD}/public"
git add .
git commit -m "site build $(date)"
ssh-agent bash -c "ssh-add /Users/ndonolli/.ssh/id_rsa; git push origin master"

cd ..
git add public
git commit -m "site build $(date)"
git push origin master
