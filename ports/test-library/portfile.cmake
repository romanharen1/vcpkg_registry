set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/romanharen1/test-library.git
    REF 79b603bbcf807091c034119d1b4cfb545251666c
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright")