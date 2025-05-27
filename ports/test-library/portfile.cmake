set(VCPKG_POLICY_ALLOW_DEBUG_INCLUDE enabled)
set(VCPKG_POLICY_SKIP_COPYRIGHT_SET enabled)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanharen1/test-library
    REF v0.0.1
    SHA512 1290bdba0f55fcdd702a3292ce00798b173fdffa0c0cc005e15dc88c6d2e7a1143c16f29fde0647b8bddd01a7c97299cc845f7dff22811a3326cf7c69f5957f3
    HEAD_REF main
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME test-library)