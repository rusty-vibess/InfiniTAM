######################
# UseRealSense.cmake #
######################

OPTION(WITH_REALSENSE "Build with Intel RealSense support?" OFF)

IF(WITH_REALSENSE)
  FIND_PACKAGE(RealSense REQUIRED)
  ADD_DEFINITIONS(-DCOMPILE_WITH_RealSense)
  infinitam_add_imported_dependency(InfiniTAMDependency::RealSense
    INCLUDES "${RealSense_INCLUDE_DIR}"
    LIBRARIES "${RealSense_LIBRARY}"
    DEFINITIONS COMPILE_WITH_RealSense
  )
ENDIF()
