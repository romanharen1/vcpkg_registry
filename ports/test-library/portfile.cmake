set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_SKIP_COPYRIGHT_SET enabled)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanharen1/test-library
    REF v0.0.1
    SHA512
    HEAD_REF v0.0.1
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)