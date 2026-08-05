######################
# UseLibRoyale.cmake #
######################

OPTION(WITH_LIBROYALE "Build with LibRoyale support?" OFF)

IF(WITH_LIBROYALE)
  FIND_PACKAGE(LibRoyale REQUIRED)
  ADD_DEFINITIONS(-DCOMPILE_WITH_LibRoyale)
  infinitam_add_imported_dependency(InfiniTAMDependency::LibRoyale
    INCLUDES "${LibRoyale_INCLUDE_DIR}"
    LIBRARIES "${LibRoyale_LIBRARY}"
    DEFINITIONS COMPILE_WITH_LibRoyale
  )
ENDIF()
