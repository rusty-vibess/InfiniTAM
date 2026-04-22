####################
# LinkOpenNI.cmake #
####################

IF(WITH_OPENNI)
  IF(TARGET InfiniTAMDependency::OpenNI)
    TARGET_LINK_LIBRARIES(${targetname} InfiniTAMDependency::OpenNI)
  ELSE()
    TARGET_LINK_LIBRARIES(${targetname} ${OPENNI_LIBRARY})
  ENDIF()

  IF(INFINITAM_BUNDLE_PLATFORM_DEPS)
    IF(MSVC_IDE)
      ADD_CUSTOM_COMMAND(TARGET ${targetname} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_if_different "${OPENNI_ROOT}/Redist/OpenNI2.dll" "$<TARGET_FILE_DIR:${targetname}>")
    ELSE()
      ADD_CUSTOM_COMMAND(TARGET ${targetname} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OPENNI_LIBRARY} $<TARGET_FILE_DIR:${targetname}>)
    ENDIF()
    ADD_CUSTOM_COMMAND(TARGET ${targetname} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory "${OPENNI_ROOT}/Redist/OpenNI2" "$<TARGET_FILE_DIR:${targetname}>/OpenNI2")
  ENDIF()
ENDIF()
