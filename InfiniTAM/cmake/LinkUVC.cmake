#################
# LinkUVC.cmake #
#################

IF(WITH_UVC)
  IF(TARGET InfiniTAMDependency::libuvc)
    TARGET_LINK_LIBRARIES(${targetname} InfiniTAMDependency::libuvc)
  ELSE()
    TARGET_LINK_LIBRARIES(${targetname} ${libuvc_LIBRARIES})
  ENDIF()
ENDIF()
