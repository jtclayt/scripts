#!/bin/bash
# Author: Justin Clayton
# This script automates staging, commiting and pushing changes, it allows for a
# message to be given to the commit and allows for an optional branch_name to
# commit to, defaulting to master.

if [ $# -gt 2 ]; then
  echo "Can only give up to 2 args" 1>&2
  exit 1
fi

if [ $# -eq 2 ]; then
  message="$2"
  branch="$1"
else
  message="$1"
  branch=master
fi

git add .
git commit -m "$message"
git push origin "$branch"
