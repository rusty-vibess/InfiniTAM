##########################################
# Top-level CMakeLists.txt for InfiniTAM #
##########################################

cmake_minimum_required(VERSION 3.16)

if(POLICY CMP0146)
  cmake_policy(SET CMP0146 OLD)
endif()

PROJECT(InfiniTAM VERSION 3.0.0 LANGUAGES C CXX)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

#################################
# Specify the CMake module path #
#################################

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

include(${CMAKE_SOURCE_DIR}/cmake/InfiniTAMDependencies.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/InfiniTAMInstallHelpers.cmake)

OPTION(INFINITAM_INSTALL_PACKAGE "Install InfiniTAM libraries, headers and CMake package files?" ON)
OPTION(INFINITAM_INSTALL_APPS "Install the InfiniTAM sample applications?" ON)
OPTION(INFINITAM_INSTALL_SAMPLE_DATA "Install bundled InfiniTAM sample data?" ON)
OPTION(INFINITAM_BUNDLE_PRIVATE_DEPS "Install explicitly project-owned private dependency roots?" ON)
OPTION(INFINITAM_BUNDLE_PLATFORM_DEPS "Bundle platform/runtime dependencies. This is intentionally off by default." OFF)
SET(INFINITAM_PRIVATE_DEP_ROOTS "" CACHE STRING "Semicolon-separated install roots for project-owned private runtime dependencies")

if(INFINITAM_PRIVATE_DEP_ROOTS)
  list(APPEND CMAKE_PREFIX_PATH ${INFINITAM_PRIVATE_DEP_ROOTS})
endif()

#################################
# Add additional compiler flags #
#################################

IF(${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -Wno-deprecated-declarations -Wno-unused-function")
ENDIF()

IF(NOT MSVC_IDE)
  SET(CFLAGS_WARN "-Wall -Wextra -Wno-unused-parameter -Wno-strict-aliasing")
  SET(CMAKE_CXX_FLAGS "-fPIC -O3 -march=native ${CFLAGS_WARN} ${CMAKE_CXX_FLAGS}")
  #SET(CMAKE_CXX_FLAGS "-fPIC -g ${CFLAGS_WARN} ${CMAKE_CXX_FLAGS}")
ENDIF()

#########################
# Suppress auto-linking #
#########################

IF(MSVC_IDE)
  ADD_DEFINITIONS(-DUSING_CMAKE=1)
ENDIF()

######################
# Add subdirectories #
######################

ADD_SUBDIRECTORY(ORUtils)
ADD_SUBDIRECTORY(MiniSlamGraphLib)
ADD_SUBDIRECTORY(FernRelocLib)
ADD_SUBDIRECTORY(ITMLib)
ADD_SUBDIRECTORY(InputSource)
ADD_SUBDIRECTORY(Apps)

#######################################
# Install headers, package and assets #
#######################################

if(INFINITAM_INSTALL_PACKAGE)
  install(DIRECTORY
    ORUtils
    MiniSlamGraphLib
    FernRelocLib
    ITMLib
    InputSource
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/InfiniTAM
    FILES_MATCHING
      PATTERN "*.h"
      PATTERN "*.tpp"
      PATTERN "*.tcu"
  )

  install(EXPORT InfiniTAMTargets
    NAMESPACE InfiniTAM::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/InfiniTAM
  )

  configure_package_config_file(
    ${CMAKE_SOURCE_DIR}/cmake/InfiniTAMConfig.cmake.in
    ${CMAKE_BINARY_DIR}/InfiniTAMConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/InfiniTAM
  )

  write_basic_package_version_file(
    ${CMAKE_BINARY_DIR}/InfiniTAMConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
  )

  configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/InfiniTAMOptions.cmake.in
    ${CMAKE_BINARY_DIR}/InfiniTAMOptions.cmake
    @ONLY
  )

  install(FILES
    ${CMAKE_BINARY_DIR}/InfiniTAMConfig.cmake
    ${CMAKE_BINARY_DIR}/InfiniTAMConfigVersion.cmake
    ${CMAKE_BINARY_DIR}/InfiniTAMOptions.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/InfiniTAM
  )

  install(DIRECTORY ${CMAKE_SOURCE_DIR}/cmake/
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/InfiniTAM/modules
    FILES_MATCHING PATTERN "Find*.cmake"
  )
endif()

if(INFINITAM_INSTALL_SAMPLE_DATA)
  install(DIRECTORY Files/
    DESTINATION ${CMAKE_INSTALL_DATADIR}/InfiniTAM/Files
  )
endif()

if(INFINITAM_BUNDLE_PRIVATE_DEPS AND INFINITAM_PRIVATE_DEP_ROOTS)
  foreach(private_dep_root ${INFINITAM_PRIVATE_DEP_ROOTS})
    if(EXISTS "${private_dep_root}/lib")
      install(DIRECTORY "${private_dep_root}/lib/"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/InfiniTAM/private
        FILES_MATCHING
          PATTERN "*.so"
          PATTERN "*.so.*"
      )
    endif()
    if(EXISTS "${private_dep_root}/bin")
      install(DIRECTORY "${private_dep_root}/bin/"
        DESTINATION ${CMAKE_INSTALL_BINDIR}
        FILES_MATCHING
          PATTERN "*.so"
          PATTERN "*.so.*"
      )
    endif()
  endforeach()
endif()
