#!/bin/bash

NEW_VERSION=$1
LIB_NAME="test-library"
PORT_DIR="ports/${LIB_NAME}"

cd $PORT_DIR

# Atualiza versão no vcpkg.json
jq ".version = \"${NEW_VERSION}\"" vcpkg.json > tmp.json && mv tmp.json vcpkg.json

# Atualiza hash
NEW_HASH=$(curl -L "https://github.com/romanharen1/${LIB_NAME}/archive/refs/tags/v${NEW_VERSION}.tar.gz" | sha512sum | cut -d' ' -f1)

sed -i "s/REF .*$/REF v${NEW_VERSION}/" portfile.cmake
sed -i "s/SHA512 .*$/SHA512 ${NEW_HASH}/" portfile.cmake

echo "Portfile atualizado para versão ${NEW_VERSION} com hash ${NEW_HASH}"
