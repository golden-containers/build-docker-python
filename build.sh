#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/python.git
cd python

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye/" 3.10/bullseye/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> 3.10/bullseye/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/python:3.10-bullseye 3.10/bullseye

# Push

docker push ghcr.io/golden-containers/python -a
