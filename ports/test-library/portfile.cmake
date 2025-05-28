set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_SKIP_COPYRIGHT_SET enabled)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanharen1/test-library
    REF v0.0.3
    SHA512 5e96518faf53f198169d1459bf85ca58357bdfabe240e7d322c97606f8ef2ddfffed12e3e4de17639aa19cf8a6b377b4746e61c75c1aa0784854d8b6fc8e8087
    HEAD_REF main
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)