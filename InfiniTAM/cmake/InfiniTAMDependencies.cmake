function(infinitam_add_imported_dependency target_name)
  set(options)
  set(one_value_args)
  set(multi_value_args INCLUDES LIBRARIES DEFINITIONS)
  cmake_parse_arguments(ARG "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT TARGET ${target_name})
    add_library(${target_name} INTERFACE IMPORTED GLOBAL)
  endif()

  if(ARG_INCLUDES)
    set_property(TARGET ${target_name} APPEND PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES "${ARG_INCLUDES}"
    )
  endif()

  if(ARG_LIBRARIES)
    set_property(TARGET ${target_name} APPEND PROPERTY
      INTERFACE_LINK_LIBRARIES "${ARG_LIBRARIES}"
    )
  endif()

  if(ARG_DEFINITIONS)
    set_property(TARGET ${target_name} APPEND PROPERTY
      INTERFACE_COMPILE_DEFINITIONS "${ARG_DEFINITIONS}"
    )
  endif()
endfunction()
