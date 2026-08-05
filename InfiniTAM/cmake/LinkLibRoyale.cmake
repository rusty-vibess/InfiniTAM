#######################
# LinkLibRoyale.cmake #
#######################

IF(WITH_LIBROYALE)
  IF(TARGET InfiniTAMDependency::LibRoyale)
    TARGET_LINK_LIBRARIES(${targetname} InfiniTAMDependency::LibRoyale)
  ELSE()
    TARGET_LINK_LIBRARIES(${targetname} ${LibRoyale_LIBRARY})
  ENDIF()
  
  IF(MSVC_IDE)
    ADD_CUSTOM_COMMAND(TARGET ${targetname} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_if_different "${LibRoyale_ROOT}/bin/royale.dll" "$<TARGET_FILE_DIR:${targetname}>")
  ENDIF()
ENDIF()
