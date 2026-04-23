function(infinitam_configure_common_target target_name)
  if(NOT TARGET ${target_name})
    return()
  endif()

  target_include_directories(${target_name} PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/InfiniTAM>
  )

  if(NOT WITH_CUDA)
    target_compile_definitions(${target_name} PUBLIC COMPILE_WITHOUT_CUDA)
  endif()

  if(NOT WITH_OPENNI)
    target_compile_definitions(${target_name} PUBLIC COMPILE_WITHOUT_OpenNI)
  endif()

  if(NOT MSKINECTAPI_FOUND)
    target_compile_definitions(${target_name} PUBLIC COMPILE_WITHOUT_Kinect2)
  endif()

  if(WITH_OPENMP AND OPENMP_FOUND)
    target_compile_definitions(${target_name} PUBLIC WITH_OPENMP)
    if(TARGET OpenMP::OpenMP_CXX)
      target_link_libraries(${target_name} OpenMP::OpenMP_CXX)
    endif()
  endif()

  set_target_properties(${target_name} PROPERTIES
    INSTALL_RPATH "$ORIGIN;$ORIGIN/../${CMAKE_INSTALL_LIBDIR};$ORIGIN/../${CMAKE_INSTALL_LIBDIR}/InfiniTAM/private;$ORIGIN/InfiniTAM/private"
  )
endfunction()

function(infinitam_configure_library_target target_name)
  infinitam_configure_common_target(${target_name})

  if("${target_name}" STREQUAL "ORUtils")
    if(WITH_PNG)
      target_compile_definitions(${target_name} PUBLIC USE_LIBPNG)
      if(TARGET PNG::PNG)
        target_link_libraries(${target_name} PNG::PNG)
      else()
        target_include_directories(${target_name} PUBLIC ${PNG_INCLUDE_DIRS})
        target_link_libraries(${target_name} ${PNG_LIBRARIES})
      endif()
    endif()
  elseif("${target_name}" STREQUAL "MiniSlamGraphLib")
    target_link_libraries(${target_name} ORUtils)
    if(WITH_CSPARSE)
      target_compile_definitions(${target_name} PUBLIC COMPILE_WITH_CSPARSE)
      if(TARGET InfiniTAMDependency::CSparse)
        target_link_libraries(${target_name} InfiniTAMDependency::CSparse)
      endif()
    endif()
  elseif("${target_name}" STREQUAL "FernRelocLib")
    target_link_libraries(${target_name} ORUtils)
  elseif("${target_name}" STREQUAL "ITMLib")
    target_link_libraries(${target_name} ORUtils MiniSlamGraphLib)
  elseif("${target_name}" STREQUAL "InputSource")
    target_link_libraries(${target_name} ORUtils ITMLib)

    if(WITH_FFMPEG AND TARGET InfiniTAMDependency::FFmpeg)
      target_compile_definitions(${target_name} PUBLIC COMPILE_WITH_FFMPEG)
      target_link_libraries(${target_name} InfiniTAMDependency::FFmpeg)
    endif()
    if(WITH_OPENNI AND TARGET InfiniTAMDependency::OpenNI)
      target_link_libraries(${target_name} InfiniTAMDependency::OpenNI)
    endif()
    if(WITH_REALSENSE AND TARGET InfiniTAMDependency::RealSense)
      target_compile_definitions(${target_name} PUBLIC COMPILE_WITH_RealSense)
      target_link_libraries(${target_name} InfiniTAMDependency::RealSense)
    endif()
    if(WITH_REALSENSE2 AND TARGET InfiniTAMDependency::RealSense2)
      target_compile_definitions(${target_name} PUBLIC COMPILE_WITH_RealSense2)
      target_link_libraries(${target_name} InfiniTAMDependency::RealSense2)
    endif()
    if(WITH_UVC AND TARGET InfiniTAMDependency::libuvc)
      target_compile_definitions(${target_name} PUBLIC COMPILE_WITH_LibUVC)
      target_link_libraries(${target_name} InfiniTAMDependency::libuvc)
    endif()
    if(WITH_LIBROYALE AND TARGET InfiniTAMDependency::LibRoyale)
      target_compile_definitions(${target_name} PUBLIC COMPILE_WITH_LibRoyale)
      target_link_libraries(${target_name} InfiniTAMDependency::LibRoyale)
    endif()
  endif()

  if(INFINITAM_INSTALL_PACKAGE)
    install(TARGETS ${target_name}
      EXPORT InfiniTAMTargets
      ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
      LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
      INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/InfiniTAM
    )
  endif()
endfunction()

function(infinitam_configure_app_target target_name)
  infinitam_configure_common_target(${target_name})

  if(INFINITAM_INSTALL_APPS)
    install(TARGETS ${target_name}
      EXPORT InfiniTAMTargets
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
  endif()
endfunction()
