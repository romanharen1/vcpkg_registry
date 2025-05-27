#!/bin/bash

set -e

REPO_URL=$1     # Ex: empresa/minha-biblioteca
VERSION=$2      # Ex: v1.3.0

LIB_NAME=$(basename "$REPO_URL")
PORT_DIR="../ports/${LIB_NAME}"
VERSIONS_DIR="../versions/-${LIB_NAME:0:1}"
VERSION_FILE="${VERSIONS_DIR}/${LIB_NAME}.json"

echo "Atualizando port ${LIB_NAME} para versão ${VERSION}"

# Clona temporariamente o repositório da biblioteca para obter SHA e gerar tarball hash
TMP_DIR=$(mktemp -d)
git clone --depth 1 --branch "${VERSION}" "https://github.com/${REPO_URL}.git" "$TMP_DIR"

cd "$TMP_DIR"

# Obtém SHA da árvore (git-tree)
GIT_TREE=$(git rev-parse HEAD^{tree})
echo "SHA da árvore: $GIT_TREE"

# Gera o hash do tar.gz do source
TAR_URL="https://github.com/${REPO_URL}/archive/refs/tags/${VERSION}.tar.gz"
TAR_HASH=$(curl -L -s "${TAR_URL}" | sha512sum | cut -d' ' -f1)
echo "Hash do tar.gz: $TAR_HASH"

cd -

# Atualiza portfile.cmake
echo "Atualizando portfile.cmake"
sed -i "s|REF .*|REF ${VERSION}|" "${PORT_DIR}/portfile.cmake"
sed -i "s|SHA512 .*|SHA512 ${TAR_HASH}|" "${PORT_DIR}/portfile.cmake"

# Atualiza vcpkg.json
echo "Atualizando vcpkg.json"
jq ".version = \"${VERSION#v}\"" "${PORT_DIR}/vcpkg.json" > "${PORT_DIR}/vcpkg_tmp.json"
mv "${PORT_DIR}/vcpkg_tmp.json" "${PORT_DIR}/vcpkg.json"

# Atualiza versions
echo "Atualizando versioning file: ${VERSION_FILE}"
mkdir -p "${VERSIONS_DIR}"

# Se já existir o arquivo, preserva as versões anteriores
if [[ -f "${VERSION_FILE}" ]]; then
  jq ".versions += [{\"version\": \"${VERSION#v.}\", \"git-tree\": \"${GIT_TREE}\"}]" \
    "${VERSION_FILE}" > "${VERSION_FILE}.tmp"
else
  cat <<EOF > "${VERSION_FILE}.tmp"
{
  "versions": [
    {
      "version": "${VERSION#v.}",
      "git-tree": "${GIT_TREE}"
    }
  ]
}
EOF
fi

mv "${VERSION_FILE}.tmp" "${VERSION_FILE}"

# Limpeza
rm -rf "$TMP_DIR"

echo "Atualização completa para ${LIB_NAME} versão ${VERSION}"
