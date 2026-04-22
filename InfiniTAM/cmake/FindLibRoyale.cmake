find_path(LibRoyale_ROOT royale_license.txt 
	HINTS ${LibRoyale_ROOT})

find_library(LibRoyale_LIBRARY
	NAMES royale
	PATHS "${LibRoyale_ROOT}/lib" {CMAKE_LIB_PATH}
)

find_path(LibRoyale_INCLUDE_DIR royale.hpp 
	PATHS "${LibRoyale_ROOT}/include"
)

if (LibRoyale_LIBRARY AND LibRoyale_INCLUDE_DIR AND LibRoyale_ROOT)
	set(LibRoyale_FOUND TRUE)
else ()
	set(LibRoyale_FOUND FALSE)
endif()
