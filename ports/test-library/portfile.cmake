set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_SKIP_COPYRIGHT_SET enabled)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanharen1/test-library
REF v0.0.2
    SHA512 9b23f0c6c44747c5f40dd721d7724f3020bf1feb5480d133d57da9f949dc0732e5e685aff81be8e41a15c6b442b9eb85e6cb5ce22133a52e972619ff44a73ed0
    HEAD_REF main
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)