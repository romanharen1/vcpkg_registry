#!/bin/bash

set -e

REPO_URL=$1     # Ex: empresa/minha-biblioteca
VERSION=$2      # Ex: v1.3.0
PORT_VERSION=${PORT_VERSION:-0}

LIB_NAME=$(basename "$REPO_URL")
PORT_DIR="../ports/${LIB_NAME}"
VERSIONS_DIR="../versions/${LIB_NAME:0:1}-"
VERSION_FILE="${VERSIONS_DIR}/${LIB_NAME}.json"
BASELINE_FILE="../versions/baseline.json"

echo "Atualizando port ${LIB_NAME} para versão ${VERSION}"

TMP_DIR=$(mktemp -d)
git clone --depth 1 --branch "${VERSION}" "https://github.com/${REPO_URL}.git" "$TMP_DIR"

cd "$TMP_DIR"

GIT_TREE=$(git rev-parse HEAD^{tree})
echo "SHA da árvore: $GIT_TREE"

TAR_URL="https://github.com/${REPO_URL}/archive/refs/tags/${VERSION}.tar.gz"
TAR_HASH=$(curl -L -s "${TAR_URL}" | sha512sum | cut -d' ' -f1)
echo "Hash do tar.gz: $TAR_HASH"

cd -

echo "Atualizando portfile.cmake"
sed -i "s/^\(\s*REF\s\).*/\1${VERSION}/" "$PORT_DIR/portfile.cmake"
sed -i "s|SHA512 .*|SHA512 ${TAR_HASH}|" "${PORT_DIR}/portfile.cmake"

echo "Atualizando vcpkg.json"
jq ".version = \"${VERSION#v}\"" "${PORT_DIR}/vcpkg.json" > "${PORT_DIR}/vcpkg_tmp.json"
mv "${PORT_DIR}/vcpkg_tmp.json" "${PORT_DIR}/vcpkg.json"

echo "Atualizando versioning file: ${VERSION_FILE}"
mkdir -p "${VERSIONS_DIR}"

if [[ -f "${VERSION_FILE}" ]]; then
  jq ".versions += [{\"version\": \"${VERSION#v}\", \"port-version\": \${PORT_VERSION}\ ,\"git-tree\": \"${GIT_TREE}\"}]" \
    "${VERSION_FILE}" > "${VERSION_FILE}.tmp"
else
  cat <<EOF > "${VERSION_FILE}.tmp"
{
  "versions": [
    {
      "version": "${VERSION#v}",
      "port-version": ${PORT_VERSION},
      "git-tree": "${GIT_TREE}"
    }
  ]
}
EOF
fi

mv "${VERSION_FILE}.tmp" "${VERSION_FILE}"

echo "Atualizando baseline em ${BASELINE_FILE}"

if [[ -f "${BASELINE_FILE}" ]]; then
  if [[ "${PORT_VERSION}" -gt 0 ]]; then
    # port-version > 0: precisa adicionar
    jq --arg lib "${LIB_NAME}" \
       --arg ver "${VERSION#v}" \
       --argjson pver "${PORT_VERSION}" \
       '.default[$lib] = { "baseline": $ver, "port-version": $pver }' \
       "${BASELINE_FILE}" > "${BASELINE_FILE}.tmp"
  else
    # Sem port-version
    jq --arg lib "${LIB_NAME}" \
       --arg ver "${VERSION#v}" \
       '.default[$lib] = { "baseline": $ver }' \
       "${BASELINE_FILE}" > "${BASELINE_FILE}.tmp"
  fi
else
  # baseline.json não existe, criar
  if [[ "${PORT_VERSION}" -gt 0 ]]; then
    cat <<EOF > "${BASELINE_FILE}.tmp"
{
  "default": {
    "${LIB_NAME}": {
      "baseline": "${VERSION#v}",
      "port-version": ${PORT_VERSION}
    }
  }
}
EOF
  else
    cat <<EOF > "${BASELINE_FILE}.tmp"
{
  "default": {
    "${LIB_NAME}": {
      "baseline": "${VERSION#v}"
    }
  }
}
EOF
  fi
fi

mv "${BASELINE_FILE}.tmp" "${BASELINE_FILE}"

echo "Baseline atualizado: ${LIB_NAME} ${VERSION} (port-version: ${PORT_VERSION})"
# Limpeza
rm -rf "$TMP_DIR"

echo "Atualização completa para ${LIB_NAME} versão ${VERSION}"
