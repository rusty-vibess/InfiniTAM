#######################
# UseRealSense2.cmake #
#######################

OPTION(WITH_REALSENSE2 "Build with Intel RealSense SDK 2 support?" OFF)

IF(WITH_REALSENSE2)
  FIND_PACKAGE(RealSense2 REQUIRED)
  ADD_DEFINITIONS(-DCOMPILE_WITH_RealSense2)
  infinitam_add_imported_dependency(InfiniTAMDependency::RealSense2
    INCLUDES "${RealSense2_INCLUDE_DIR}"
    LIBRARIES "${RealSense2_LIBRARY}"
    DEFINITIONS COMPILE_WITH_RealSense2
  )
ENDIF()
