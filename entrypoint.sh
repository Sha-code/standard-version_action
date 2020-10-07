#!/bin/bash

if [ $INPUT_DRY_RUN ]; then INPUT_DRY_RUN='--dry-run'; else INPUT_DRY_RUN=''; fi
if [ $INPUT_CHANGELOG ]; then INPUT_CHANGELOG=''; else INPUT_CHANGELOG='--skip.changelog'; fi
if [ $INPUT_PRERELEASE ]; then INPUT_PRERELEASE="--prerelease $INPUT_PRERELEASE"; else INPUT_PRERELEASE=''; fi
INPUT_BRANCH=${INPUT_BRANCH:-master}
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
# : "${INPUT_CHANGELOG:=true}" ignroed for now, let's check that it works

set -e

[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

echo "Repository: $REPOSITORY"
echo "Actor: $GITHUB_ACTOR"

echo "Installing requirements..."
npm i -g standard-version

echo "Configuring git user and email..."
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"


echo "Running standard-version: $INPUT_DRY_RUN $INPUT_CHANGELOG $INPUT_PRERELEASE"
standard-version $INPUT_DRY_RUN $INPUT_CHANGELOG $INPUT_PRERELEASE


echo "Pushing to branch..."
remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"
git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags --tags;
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')
PACKAGE_TYPE=${(echo $PACKAGE_VERSION | grep -o 'alpha\|beta\|rc'):-production}
echo "::set-output name=release_version::$PACKAGE_VERSION"
echo "::set-output name=release_type::$PACKAGE_TYPE"
echo "Done."