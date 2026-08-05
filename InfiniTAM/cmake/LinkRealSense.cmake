#######################
# LinkRealSense.cmake #
#######################

IF(WITH_REALSENSE)
  IF(TARGET InfiniTAMDependency::RealSense)
    TARGET_LINK_LIBRARIES(${targetname} InfiniTAMDependency::RealSense)
  ELSE()
    TARGET_LINK_LIBRARIES(${targetname} ${RealSense_LIBRARY})
  ENDIF()
ENDIF()
