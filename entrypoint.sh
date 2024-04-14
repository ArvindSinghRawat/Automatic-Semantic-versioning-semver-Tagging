#!/bin/bash

NEW_VERSION=''

# Function to get the current version based on the latest tag
function get_current_version {
    # Get the latest tag across all branches, not just the current branch
    local VERSION=`git describe --abbrev=0 --tags 2>/dev/null`

    if [[ $VERSION == '' ]]
    then
        VERSION='0.0.0'
    fi
    echo "$VERSION"
}

# Function to update the version based on commit message
function update_version {
    # Updates the provided version to the next version based on the commit message
    # Takes the current version in Semantic versioning format, for example: 0.0.1 (without any prefix or suffix)
    local CURRENT_VERSION=$1
    local NEXT_VERSION=''
    if [[ $CURRENT_VERSION == '' ]]
    then
        NEXT_VERSION='0.0.1'
    else
        local VERSION_PARTS=(${CURRENT_VERSION//./ })
        to_number ${VERSION_PARTS[0]}
        V_MAJOR=$?
        to_number ${VERSION_PARTS[1]}
        V_MINOR=$?
        to_number ${VERSION_PARTS[2]}
        V_PATCH=$?

        local IS_MAJOR_CHANGE=`git log -1 --pretty=%B | egrep -ci '^(breaking)|(release)|(major)'`
        local IS_MINOR_CHANGE=`git log -1 --pretty=%B | egrep -ci '^(feature)|(minor)'`

        if [ $IS_MAJOR_CHANGE -gt 0 ]; 
        then
            V_MAJOR=$((V_MAJOR+1))
            V_MINOR=0
            V_PATCH=0
        elif [ $IS_MINOR_CHANGE -gt 0 ];
        then
            V_MINOR=$((V_MINOR+1))
            V_PATCH=0
        else
            V_PATCH=$((V_PATCH+1))
        fi
        NEXT_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"
    fi
    NEW_VERSION="$NEXT_VERSION"
}

# Function to check whether provided string is a number or not
function to_number {
    # Checks if provided parameter is a number or not. If not, then defaults to Zero.
    echo "Provided value is $1"
    local VALUE=$1
    if [[ $VALUE =~ ^[0-9]+$ ]];
    then
        return $VALUE
    else
        return 0
    fi
}

echo "Starting the tagging process based on commit message +semver: xxxxx"

git config --global --add safe.directory '*'

cd ${GITHUB_WORKSPACE}/${source}

# Get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`


# Only tag if the commit message has the version-bump-message as mentioned in docs
if [ -z "$NEEDS_TAG" ]; then
    # Get the latest tag across all branches, not just the current branch
    # Ignore in case of error, generally happens if no tag is present
    VERSION=$(get_current_version)
    echo "Current Version: $VERSION"

    # Create a new version from the existing tag
    update_version $VERSION
    echo "Latest version tag is: $NEW_VERSION"

    if [[ $NEW_VERSION == '' ]];
    then
        echo "Tag is not yet set" >&2
        exit 1
    fi

    git tag "$NEW_VERSION"
    echo "Tagged with $NEW_VERSION (Ignoring fatal:cannot describe - this means commit is untagged) "
    set -e
    git push origin $NEW_VERSION --verbose
    echo "Success"
else
    echo "Already a tag on this commit"
fi
