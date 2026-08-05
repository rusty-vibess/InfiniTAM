cmake_minimum_required(VERSION 3.16)

project(InfiniTAMPackageConsumerSmoke LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(InfiniTAM REQUIRED CONFIG)

if(NOT DEFINED InfiniTAM_VOXEL_TYPE)
  message(FATAL_ERROR "Package metadata is missing InfiniTAM_VOXEL_TYPE")
endif()
if(NOT DEFINED InfiniTAM_VOXEL_HAS_COLOR)
  message(FATAL_ERROR "Package metadata is missing InfiniTAM_VOXEL_HAS_COLOR")
endif()

function(assert_imported_target target_name)
  if(NOT TARGET ${target_name})
    message(FATAL_ERROR "Missing imported target: ${target_name}")
  endif()
endfunction()

function(assert_internal_dependency target_name dependency_name)
  get_target_property(link_deps ${target_name} INTERFACE_LINK_LIBRARIES)
  list(FIND link_deps "${dependency_name}" dependency_index)
  if(dependency_index EQUAL -1)
    message(FATAL_ERROR
      "${target_name} is missing internal dependency ${dependency_name}. "
      "INTERFACE_LINK_LIBRARIES=${link_deps}"
    )
  endif()
endfunction()

assert_imported_target(InfiniTAM::ORUtils)
assert_imported_target(InfiniTAM::FernRelocLib)
assert_imported_target(InfiniTAM::MiniSlamGraphLib)
assert_imported_target(InfiniTAM::ITMLib)
assert_imported_target(InfiniTAM::InputSource)

assert_internal_dependency(InfiniTAM::FernRelocLib InfiniTAM::ORUtils)
assert_internal_dependency(InfiniTAM::MiniSlamGraphLib InfiniTAM::ORUtils)
assert_internal_dependency(InfiniTAM::ITMLib InfiniTAM::ORUtils)
assert_internal_dependency(InfiniTAM::ITMLib InfiniTAM::MiniSlamGraphLib)
assert_internal_dependency(InfiniTAM::ITMLib InfiniTAM::FernRelocLib)
assert_internal_dependency(InfiniTAM::InputSource InfiniTAM::ORUtils)
assert_internal_dependency(InfiniTAM::InputSource InfiniTAM::ITMLib)

add_executable(itmlib_smoke itmlib_smoke.cpp)
target_link_libraries(itmlib_smoke PRIVATE InfiniTAM::ITMLib)
