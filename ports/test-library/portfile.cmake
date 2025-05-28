set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_SKIP_COPYRIGHT_SET enabled)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanharen1/test-library
    REF v0.0.5
    SHA512 7b18ecdd1050c6045c2769ea1325a55ed175e5840cfd7ce25abf7e4a010f90b6b7ac8287dd78469edcc0df3dd4ca7fdf9481db2c0d21eebd842b46fdb9c7cd43
    HEAD_REF main
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)