## Copyright 2021 Intel Corporation
## SPDX-License-Identifier: Apache-2.0

set(COMPONENT_NAME snappy)

if (INSTALL_IN_SEPARATE_DIRECTORIES)
  set(COMPONENT_PATH ${INSTALL_DIR_ABSOLUTE}/${COMPONENT_NAME})
else()
  set(COMPONENT_PATH ${INSTALL_DIR_ABSOLUTE})
endif()

if (NOT WIN32)
  set(PATCH sed -ie "s/size_t AdvanceToNextTag/inline size_t AdvanceToNextTag/" snappy.cc)
endif()

ExternalProject_Add(${COMPONENT_NAME}
  URL "https://github.com/google/snappy/archive/refs/tags/1.1.9.zip"
  URL_HASH "SHA256=e170ce0def2c71d0403f5cda61d6e2743373f9480124bcfcd0fa9b3299d428d9"

  PATCH_COMMAND ${PATCH}

  # Skip updating on subsequent builds (faster)
  UPDATE_COMMAND ""

  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX:PATH=${COMPONENT_PATH}
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DSNAPPY_BUILD_TESTS:BOOL=OFF
    -DSNAPPY_BUILD_BENCHMARKS:BOOL=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
    -DCMAKE_BUILD_TYPE=${DEPENDENCIES_BUILD_TYPE}
)

list(APPEND CMAKE_PREFIX_PATH ${COMPONENT_PATH})
string(REPLACE ";" "|" CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}")
