#!/bin/bash

echo -e "Enter the new branch name (e.g. 8.3.x):"
read b
echo -e "Enter the original branch name (e.g. 8.2.x):"
read pb

n=${b/x/0}
cn=${b/.x/}
p=${pb/x/0}
cp=${pb/.x/}

git checkout "$pb"
git pull
rm -rf vendor
composer install
git checkout -b "$b"
# @todo Make it fail if the following don't make changes.
sed -i '' -e "s/VERSION = '[0-9\.]*-dev'/VERSION = '$n-dev'/1" core/lib/Drupal.php
composer self-update
COMPOSER_ROOT_VERSION="$b-dev" composer update drupal/core*
git commit -am "Drupal $b-dev"


