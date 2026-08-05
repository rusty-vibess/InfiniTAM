####################
# LinkOpenGL.cmake #
####################

IF(TARGET OpenGL::GL)
  TARGET_LINK_LIBRARIES(${targetname} OpenGL::GL)
ELSEIF(OPENGL_LIBRARIES)
  TARGET_LINK_LIBRARIES(${targetname} ${OPENGL_LIBRARIES})
ELSE()
  TARGET_LINK_LIBRARIES(${targetname} ${OPENGL_LIBRARY})
ENDIF()
