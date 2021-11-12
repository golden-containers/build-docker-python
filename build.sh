#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/python.git
cd python

# Transform

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED} -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye/" 3.10/bullseye/Dockerfile

# Build

docker build 3.10/bullseye/ --tag ghcr.io/golden-containers/python:3.10-bullseye --label ${1:-DEBUG=TRUE}

# Push

docker push ghcr.io/golden-containers/python -a
