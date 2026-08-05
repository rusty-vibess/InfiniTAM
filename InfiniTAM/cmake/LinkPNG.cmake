#################
# LinkPNG.cmake #
#################

IF(WITH_PNG)
  IF(TARGET PNG::PNG)
    TARGET_LINK_LIBRARIES(${targetname} PNG::PNG)
  ELSE()
    TARGET_LINK_LIBRARIES(${targetname} ${PNG_LIBRARIES})
  ENDIF()
ENDIF()
