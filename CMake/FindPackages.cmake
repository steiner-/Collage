# generated by Buildyard, do not edit.

include(System)
list(APPEND FIND_PACKAGES_DEFINES ${SYSTEM})

find_package(OFED )
if(OFED_FOUND)
  set(OFED_name OFED)
endif()
if(OFED_FOUND)
  set(OFED_name OFED)
endif()
if(OFED_name)
  list(APPEND FIND_PACKAGES_DEFINES COLLAGE_USE_OFED)
  set(FIND_PACKAGES_FOUND "${FIND_PACKAGES_FOUND} OFED")
  link_directories(${${OFED_name}_LIBRARY_DIRS})
  if(NOT "${${OFED_name}_INCLUDE_DIRS}" MATCHES "-NOTFOUND")
    include_directories(${${OFED_name}_INCLUDE_DIRS})
  endif()
endif()

find_package(UDT )
if(UDT_FOUND)
  set(UDT_name UDT)
endif()
if(UDT_FOUND)
  set(UDT_name UDT)
endif()
if(UDT_name)
  list(APPEND FIND_PACKAGES_DEFINES COLLAGE_USE_UDT)
  set(FIND_PACKAGES_FOUND "${FIND_PACKAGES_FOUND} UDT")
  link_directories(${${UDT_name}_LIBRARY_DIRS})
  if(NOT "${${UDT_name}_INCLUDE_DIRS}" MATCHES "-NOTFOUND")
    include_directories(${${UDT_name}_INCLUDE_DIRS})
  endif()
endif()

find_package(Boost 1.41.0 REQUIRED system regex date_time serialization)
if(Boost_FOUND)
  set(Boost_name Boost)
endif()
if(BOOST_FOUND)
  set(Boost_name BOOST)
endif()
if(Boost_name)
  list(APPEND FIND_PACKAGES_DEFINES COLLAGE_USE_BOOST)
  set(FIND_PACKAGES_FOUND "${FIND_PACKAGES_FOUND} Boost")
  link_directories(${${Boost_name}_LIBRARY_DIRS})
  if(NOT "SYSTEM ${${Boost_name}_INCLUDE_DIRS}" MATCHES "-NOTFOUND")
    include_directories(SYSTEM ${${Boost_name}_INCLUDE_DIRS})
  endif()
endif()

find_package(Lunchbox 1.9.0 REQUIRED)
if(Lunchbox_FOUND)
  set(Lunchbox_name Lunchbox)
endif()
if(LUNCHBOX_FOUND)
  set(Lunchbox_name LUNCHBOX)
endif()
if(Lunchbox_name)
  list(APPEND FIND_PACKAGES_DEFINES COLLAGE_USE_LUNCHBOX)
  set(FIND_PACKAGES_FOUND "${FIND_PACKAGES_FOUND} Lunchbox")
  link_directories(${${Lunchbox_name}_LIBRARY_DIRS})
  if(NOT "${${Lunchbox_name}_INCLUDE_DIRS}" MATCHES "-NOTFOUND")
    include_directories(${${Lunchbox_name}_INCLUDE_DIRS})
  endif()
endif()


if(EXISTS ${CMAKE_SOURCE_DIR}/CMake/FindPackagesPost.cmake)
  include(${CMAKE_SOURCE_DIR}/CMake/FindPackagesPost.cmake)
endif()

set(COLLAGE_BUILD_DEBS libavahi-compat-libdnssd-dev;libboost-date-time-dev;libboost-regex-dev;libboost-serialization-dev;libboost-system-dev;libhwloc-dev;libibverbs-dev;libjpeg-turbo8-dev;librdmacm-dev;libturbojpeg;libudt-dev)

set(COLLAGE_DEPENDS OFED;UDT;Boost;Lunchbox)

# Write defines.h and options.cmake
if(NOT PROJECT_INCLUDE_NAME)
  set(PROJECT_INCLUDE_NAME ${CMAKE_PROJECT_NAME})
endif()
if(NOT OPTIONS_CMAKE)
  set(OPTIONS_CMAKE ${CMAKE_BINARY_DIR}/options.cmake)
endif()
set(DEFINES_FILE "${CMAKE_BINARY_DIR}/include/${PROJECT_INCLUDE_NAME}/defines${SYSTEM}.h")
set(DEFINES_FILE_IN ${DEFINES_FILE}.in)
file(WRITE ${DEFINES_FILE_IN}
  "// generated by CMake/FindPackages.cmake, do not edit.\n\n"
  "#ifndef ${CMAKE_PROJECT_NAME}_DEFINES_${SYSTEM}_H\n"
  "#define ${CMAKE_PROJECT_NAME}_DEFINES_${SYSTEM}_H\n\n")
file(WRITE ${OPTIONS_CMAKE} "# Optional modules enabled during build\n")
foreach(DEF ${FIND_PACKAGES_DEFINES})
  add_definitions(-D${DEF})
  file(APPEND ${DEFINES_FILE_IN}
  "#ifndef ${DEF}\n"
  "#  define ${DEF}\n"
  "#endif\n")
if(NOT DEF STREQUAL SYSTEM)
  file(APPEND ${OPTIONS_CMAKE} "set(${DEF} ON)\n")
endif()
endforeach()
file(APPEND ${DEFINES_FILE_IN}
  "\n#endif\n")

include(UpdateFile)
update_file(${DEFINES_FILE_IN} ${DEFINES_FILE})
if(Boost_FOUND) # another WAR for broken boost stuff...
  set(Boost_VERSION ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION})
endif()
if(CUDA_FOUND)
  string(REPLACE "-std=c++11" "" CUDA_HOST_FLAGS "${CUDA_HOST_FLAGS}")
  string(REPLACE "-std=c++0x" "" CUDA_HOST_FLAGS "${CUDA_HOST_FLAGS}")
endif()
if(FIND_PACKAGES_FOUND)
  message(STATUS "Configured with ${CMAKE_BUILD_TYPE}${FIND_PACKAGES_FOUND}")
endif()
