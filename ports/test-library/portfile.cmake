set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_SKIP_COPYRIGHT_SET enabled)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanharen1/test-library
    REF v0.0.4
    SHA512 a375921372d42dbc6c2b572a6616ca59df7238f5209188f8bc3201988a2c54ef54b0508da95967897c1dfbfa3a22607ed6c4530bc6c1a674d1027c28d7821960
    HEAD_REF main
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)