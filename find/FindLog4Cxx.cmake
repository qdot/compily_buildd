# - Find the log4cxx library.
# Find the native log4cxx includes and library
# This module defines
#  LOG4CXX_INCLUDE_DIR, where to find jpeglib.h, etc.
#  LOG4CXX_LIBRARIES, the libraries needed to use LOG4CXX.
#  LOG4CXX_FOUND, If false, do not try to use LOG4CXX.
# also defined, but not for general use are
#  LOG4CXX_LIBRARY, where to find the LOG4CXX library.

FIND_PATH(LOG4CXX_INCLUDE_DIR log4cxx/log4cxx.h
/usr/local/include
/usr/include
)

SET(LOG4CXX_NAMES ${LOG4CXX_NAMES} log4cxx)
FIND_LIBRARY(LOG4CXX_LIBRARY
  NAMES ${LOG4CXX_NAMES}
  PATHS /usr/lib /usr/local/lib
  )

IF (LOG4CXX_LIBRARY AND LOG4CXX_INCLUDE_DIR)
    SET(LOG4CXX_LIBRARIES ${LOG4CXX_LIBRARY})
    SET(LOG4CXX_FOUND "YES")
ELSE (LOG4CXX_LIBRARY AND LOG4CXX_INCLUDE_DIR)
  SET(LOG4CXX_FOUND "NO")
ENDIF (LOG4CXX_LIBRARY AND LOG4CXX_INCLUDE_DIR)


IF (LOG4CXX_FOUND)
   IF (NOT LOG4CXX_FIND_QUIETLY)
      MESSAGE(STATUS "Found LOG4CXX: ${LOG4CXX_LIBRARIES}")
   ENDIF (NOT LOG4CXX_FIND_QUIETLY)
ELSE (LOG4CXX_FOUND)
   IF (LOG4CXX_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find LOG4CXX library")
   ENDIF (LOG4CXX_FIND_REQUIRED)
ENDIF (LOG4CXX_FOUND)

# Deprecated declarations.
SET (NATIVE_LOG4CXX_INCLUDE_PATH ${LOG4CXX_INCLUDE_DIR} )
GET_FILENAME_COMPONENT (NATIVE_LOG4CXX_LIB_PATH ${LOG4CXX_LIBRARY} PATH)

MARK_AS_ADVANCED(
  LOG4CXX_LIBRARY
  LOG4CXX_INCLUDE_DIR
  )
