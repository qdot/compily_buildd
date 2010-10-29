######################################################################################
# Add subdirectories
######################################################################################

# Add path for scripts we use to generate files
SET(BUILDSYS_SCRIPT_DIR ${BUILDSYS_CMAKE_DIR}/scripts)

# Add local module path for find modules
LIST(APPEND CMAKE_MODULE_PATH ${BUILDSYS_CMAKE_DIR}/cmake_modules)
# Add our repository cmake_modules directory
LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules)

# Add local macros and project options
INCLUDE(${BUILDSYS_CMAKE_DIR}/CMakeOptions.cmake)
INCLUDE(${BUILDSYS_CMAKE_DIR}/CMakeFunctions.cmake)

######################################################################################
# Project Setup
######################################################################################

# ------------------------------------------------------------------------------
# INITIALIZE_BUILD is a beast of a macro that defines a lot of
# defaults about what we expect to be in projects. Instead of
# documenting all of the functionality here, I've added comment blocks
# through the functions since it does so much.
#
# ------------------------------------------------------------------------------

MACRO(INITIALIZE_BUILD)

  MACRO_ENSURE_OUT_OF_SOURCE_BUILD()

  # Set up default install directories if they aren't set for us
  IF(UNIX)
    IF(NOT CMAKE_INSTALL_PREFIX)
      SET(CMAKE_INSTALL_PREFIX /usr/local)
    ENDIF()
  ENDIF()

  IF(CMAKE_INSTALL_PREFIX)
    MESSAGE(STATUS "Installation Prefix: ${CMAKE_INSTALL_PREFIX}")
  ENDIF()

  # Set up defaults to look like "usr" format. We want all of our
  # projects in this layout.
  IF(NOT INCLUDE_INSTALL_DIR)
    SET(INCLUDE_INSTALL_DIR include)
  ENDIF()
  IF(NOT LIBRARY_INSTALL_DIR)
    SET(LIBRARY_INSTALL_DIR lib)
  ENDIF()
  IF(NOT RUNTIME_INSTALL_DIR)
    SET(RUNTIME_INSTALL_DIR bin)
  ENDIF()
  IF(NOT SYMBOL_INSTALL_DIR)
    SET(SYMBOL_INSTALL_DIR debug)
  ENDIF()
  IF(NOT DOC_INSTALL_DIR)
    SET(DOC_INSTALL_DIR doc)
  ENDIF()
  IF(NOT FRAMEWORK_INSTALL_DIR)
    SET(FRAMEWORK_INSTALL_DIR frameworks)
  ENDIF()
  IF(NOT CMAKE_MODULES_INSTALL_DIR)
    SET(CMAKE_MODULES_INSTALL_DIR cmake_modules)
  ENDIF()

  # We always want to output our binaries and libraries to the same place, set that here
  SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
  SET(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
  SET(DOC_OUTPUT_PATH ${CMAKE_BINARY_DIR}/doc)

  #Always assume we want to build threadsafe mingw binaries
  IF(MINGW)
    LIST(APPEND BUILDSYS_GLOBAL_DEFINES -mthreads)
    SET(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} -mthreads")
  ENDIF()

  #defines we always need on gcc compilers
  IF(CMAKE_COMPILER_IS_GNUCXX)
    LIST(APPEND BUILDSYS_GLOBAL_DEFINES
      -DREENTRANT
      -D_REENTRANT
      -D_THREAD_SAFE
      -D_FILE_OFFSET_BITS=64
      -D_LARGEFILE_SOURCE
      )
  ENDIF()

  IF(NOT MINGW)
    LIST(APPEND BUILDSYS_GLOBAL_DEFINES -D__STDC_LIMIT_MACROS)
  ENDIF()

  FOREACH(DEFINE ${BUILDSYS_GLOBAL_DEFINES})
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${DEFINE}")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${DEFINE}")
  ENDFOREACH(DEFINE ${BUILDSYS_GLOBAL_DEFINES})	

  #taken from OpenSceneGraph CMake.
  #Handy visual studio functions
  #Assuming /MP to always be on though
  IF(MSVC)

    # Fun with MSVC2010 linking 
    # 
    # As of VS2010, the "setting PREFIX to ../" hack no longer works
    # to avoid VS's injection of build types into the library output
    # path. Therefore, we have to set everything ourselves here.  I
    # pulled this block from the OutDir test in the cmake source code,
    # because it's not really documented otherwise.
    # 
    # Good times.

    if(CMAKE_CONFIGURATION_TYPES)
      foreach(config ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER "${config}" CONFIG)
        list(APPEND configs "${CONFIG}")
      endforeach()
      set(CMAKE_BUILD_TYPE)
    elseif(NOT CMAKE_BUILD_TYPE)
      set(CMAKE_BUILD_TYPE Debug)
    endif()

    # Now that we've gathered the configurations we're using, set them
    # all to the paths without the configuration type
    FOREACH(config ${configs})
      SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${config} "${LIBRARY_OUTPUT_PATH}")
      SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${config} "${LIBRARY_OUTPUT_PATH}")
      SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${config} "${EXECUTABLE_OUTPUT_PATH}")
    ENDFOREACH()

    # Check to see if we're using nmake. If so, set the NMAKE variable
    IF(CMAKE_MAKE_PROGRAM STREQUAL "nmake")
      SET(NMAKE 1)
    ENDIF()

    # Turn on PDB building
    OPTION(BUILDSYS_GLOBAL_INSTALL_PDB "When building DLLs or EXEs, always build and store a PDB file" OFF)

    # This option is to enable the /MP switch for Visual Studio 2005 and above compilers
    OPTION(WIN32_USE_MP "Set to ON to build with the /MP multiprocessor compile option (Visual Studio 2005 and above)." ON)
    IF(WIN32_USE_MP)
      SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
    ENDIF()

    # More MSVC specific compilation flags
    ADD_DEFINITIONS(-D_SCL_SECURE_NO_WARNINGS)
    ADD_DEFINITIONS(-D_CRT_SECURE_NO_DEPRECATE)

    #Assume we always want NOMINMAX defined, and lean and mean,
    #and no winsock1. Tends to throw redefinition warnings, but eh.
    ADD_DEFINITIONS(-DNOMINMAX -DWIN32_LEAN_AND_MEAN)
  ENDIF()
  
  IF(APPLE)
    SET(BUILDSYS_FRAMEWORKS)
  ENDIF()

ENDMACRO(INITIALIZE_BUILD)