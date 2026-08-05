########################
# LinkRealSense2.cmake #
########################

IF(WITH_REALSENSE2)
  IF(TARGET InfiniTAMDependency::RealSense2)
    TARGET_LINK_LIBRARIES(${targetname} InfiniTAMDependency::RealSense2)
  ELSE()
    TARGET_LINK_LIBRARIES(${targetname} ${RealSense2_LIBRARY})
  ENDIF()
ENDIF()
