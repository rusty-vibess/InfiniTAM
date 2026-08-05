################
# UseUVC.cmake #
################

OPTION(WITH_UVC "Build with libuvc support?" OFF)

IF(WITH_UVC)
  FIND_PACKAGE(libuvc REQUIRED)

  ADD_DEFINITIONS(-DCOMPILE_WITH_LibUVC)
  infinitam_add_imported_dependency(InfiniTAMDependency::libuvc
    INCLUDES "${libuvc_INCLUDE_DIRS}"
    LIBRARIES "${libuvc_LIBRARIES}"
    DEFINITIONS COMPILE_WITH_LibUVC
  )
ENDIF()
