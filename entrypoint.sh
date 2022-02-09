#!/bin/bash

echo "Starting the taging process based on commit message +semver: xxxxx"

cd ${GITHUB_WORKSPACE}/${source}

#get highest tags across all branches, not just the current branch
VERSION=`git describe --abbrev=0 --tags 2>/dev/null`

if [[ $VERSION == '' ]]
then
  VERSION='0.0.0'
fi
echo "Current Version: $VERSION"

# split into array
VERSION_BITS=(${VERSION//./ })

echo "Latest version tag: $VERSION"

#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}

COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MAJOR=`git log -1 --pretty=%B | egrep -ci '^(breaking)|(major)'`
COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MINOR=`git log -1 --pretty=%B | egrep -ci '^(feature)|(minor)'`
TO_PUSH=false

if [ $COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MAJOR -gt 0 ]; then
    VNUM1=$((VNUM1+1))
    VNUM2=0
    VNUM3=0
    TO_PUSH=true
elif [ $COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MINOR -gt 0 ]; then
    VNUM2=$((VNUM2+1)) 
    VNUM3=0
    TO_PUSH=true
else
    VNUM3=$((VNUM3+1)) 
    TO_PUSH=true
fi

#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

echo "Updating $VERSION to $NEW_TAG"

#get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`


#only tag if commit message have version-bump-message as mentioned above
if [ -z "$NEEDS_TAG" ]; then
    if [ $TO_PUSH ]; then
        echo "Tagged with $NEW_TAG (Ignoring fatal:cannot describe - this means commit is untagged) "
        git tag "$NEW_TAG"
        # git push origin $NEW_TAG -f
        git push origin $NEW_TAG
        echo "Success"
    else
        echo "Failed"
    fi
else
    echo "Already a tag on this commit"
fi