function(run_or_fail)
  set(options)
  set(one_value_args WORKING_DIRECTORY)
  set(multi_value_args COMMAND)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT ARG_COMMAND)
    message(FATAL_ERROR "run_or_fail requires COMMAND")
  endif()

  if(ARG_WORKING_DIRECTORY)
    execute_process(
      COMMAND ${ARG_COMMAND}
      WORKING_DIRECTORY "${ARG_WORKING_DIRECTORY}"
      RESULT_VARIABLE command_result
      OUTPUT_VARIABLE command_output
      ERROR_VARIABLE command_error
    )
  else()
    execute_process(
      COMMAND ${ARG_COMMAND}
      RESULT_VARIABLE command_result
      OUTPUT_VARIABLE command_output
      ERROR_VARIABLE command_error
    )
  endif()

  if(NOT command_result EQUAL 0)
    message(FATAL_ERROR
      "Command failed: ${ARG_COMMAND}\n"
      "stdout:\n${command_output}\n"
      "stderr:\n${command_error}"
    )
  endif()
endfunction()

set(package_smoke_install_dir "${TEST_BINARY_DIR}/install")
set(package_smoke_build_dir "${TEST_BINARY_DIR}/consumer-build")
set(package_smoke_source_dir "${TEST_SOURCE_DIR}/package-consumer")

file(REMOVE_RECURSE "${TEST_BINARY_DIR}")
file(MAKE_DIRECTORY "${TEST_BINARY_DIR}")

set(install_command
  ${CMAKE_COMMAND}
  --install "${PRODUCER_BINARY_DIR}"
  --prefix "${package_smoke_install_dir}"
)
if(NOT "${TEST_CONFIG}" STREQUAL "")
  list(APPEND install_command --config "${TEST_CONFIG}")
endif()
run_or_fail(COMMAND ${install_command})

set(configure_command
  ${CMAKE_COMMAND}
  -S "${package_smoke_source_dir}"
  -B "${package_smoke_build_dir}"
  "-DCMAKE_PREFIX_PATH=${package_smoke_install_dir}"
)
if(NOT "${PRODUCER_GENERATOR}" STREQUAL "")
  list(APPEND configure_command -G "${PRODUCER_GENERATOR}")
endif()
if(NOT "${PRODUCER_GENERATOR_PLATFORM}" STREQUAL "")
  list(APPEND configure_command -A "${PRODUCER_GENERATOR_PLATFORM}")
endif()
if(NOT "${PRODUCER_GENERATOR_TOOLSET}" STREQUAL "")
  list(APPEND configure_command -T "${PRODUCER_GENERATOR_TOOLSET}")
endif()
if(NOT "${PRODUCER_BUILD_TYPE}" STREQUAL "")
  list(APPEND configure_command "-DCMAKE_BUILD_TYPE=${PRODUCER_BUILD_TYPE}")
endif()
if(NOT "${PRODUCER_C_COMPILER}" STREQUAL "")
  list(APPEND configure_command "-DCMAKE_C_COMPILER=${PRODUCER_C_COMPILER}")
endif()
if(NOT "${PRODUCER_CXX_COMPILER}" STREQUAL "")
  list(APPEND configure_command "-DCMAKE_CXX_COMPILER=${PRODUCER_CXX_COMPILER}")
endif()
if(NOT "${PRODUCER_TOOLCHAIN_FILE}" STREQUAL "")
  list(APPEND configure_command "-DCMAKE_TOOLCHAIN_FILE=${PRODUCER_TOOLCHAIN_FILE}")
endif()
run_or_fail(COMMAND ${configure_command})

set(build_command
  ${CMAKE_COMMAND}
  --build "${package_smoke_build_dir}"
  --target itmlib_smoke
)
if(NOT "${TEST_CONFIG}" STREQUAL "")
  list(APPEND build_command --config "${TEST_CONFIG}")
endif()
run_or_fail(COMMAND ${build_command})
