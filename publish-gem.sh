#!/bin/bash

# Check if the GitHub reference starts with 'refs/tags/v' or 'refs/tags/build-'
# if [[ $GITHUB_REF_VALUE == refs/tags/v* ]] || [[ $GITHUB_REF_VALUE == refs/tags/build-* ]]; then
GEMS_PATH="pkg/*.gem"
RUBYGEMS_HOST="https://sageonegems.jfrog.io/artifactory/api/gems/gems-local"
JFROG_USER="JFROG_USER_VALUE"
JFROG_PASS="JFROG_PASS_VALUE"

# Clear any existing packages
rm -f $GEMS_PATH

# Retrieve credentials
mkdir -p $HOME/.gem
curl -u $JFROG_USER:$JFROG_PASS $RUBYGEMS_HOST/api/v1/api_key.yaml > $HOME/.gem/credentials
chmod 600 $HOME/.gem/credentials

# Build gem
bundle exec rake build

# Publish
# gem push $GEMS_PATH
# fi