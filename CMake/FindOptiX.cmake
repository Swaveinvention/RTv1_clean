#
# Copyright (c) 2023, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# NOTE: Propose Optix distribution location by setting OPTIX_INSTALL_DIR in parent scope!

set(OPTIX_INSTALL_DIR_SDK_DEFAULT       "${CMAKE_SOURCE_DIR}/../" CACHE PATH "Path to Optix location, if called from SDK." INTERNAL)

# TODO: Make agnostic for Optix versions. Try to find highest version
if(WIN32)
    set(OPTIX_INSTALL_DIR_SYS_DEFAULT    "C:/ProgramData/NVIDIA Corporation/OptiX SDK 8.0.0" CACHE PATH "Path to Optix location, if installed to default location in windows." INTERNAL)
elseif( APPLE )
    # FIXME: FIX Linux/MacOS default locations.
    set(OPTIX_INSTALL_DIR_SYS_DEFAULT    "/usr/local/share/NVIDIA Corporation/OptiX SDK 8.0.0" CACHE PATH "Path to Optix location, if installed to default location in MacOS." INTERNAL)
else()
    # FIXME: FIX Linux/MacOS default locations.
    set(OPTIX_INSTALL_DIR_SYS_DEFAULT    "/usr/local/share/NVIDIA Corporation/OptiX SDK 8.0.0" CACHE PATH "Path to Optix location, if installed to default location in linux." INTERNAL)
endif()

# Locate the OptiX distribution. Search in OPTIX_INSTALL_DIR first, if unset check relative to CMAKE_SOURCE_DIR.
if(NOT DEFINED OPTIX_INSTALL_DIR)
    # Assuming that this is called from ROOT CMakeLists.txt in SDK, check there first, if no directory is set.
    set(OPTIX_INSTALL_DIR "${CMAKE_SOURCE_DIR}/../" CACHE PATH "Path to OptiX installed location.")
    # Make option visible
endif()
set(install_dir_list "${OPTIX_INSTALL_DIR};${OPTIX_INSTALL_DIR_SDK_DEFAULT};${OPTIX_INSTALL_DIR_SYS_DEFAULT}")

# The distribution contains only 64 bit libraries. Error when we have been mis-configured.
if(NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
  if(WIN32)
    message(SEND_ERROR "Make sure when selecting the generator, you select one with Win64 or x64.")
  endif()
  message(FATAL_ERROR "OptiX only supports builds configured for 64 bits.")
endif()

# search path based on the bit-ness of the build.  (i.e. 64: bin64, lib64; 32:
# bin, lib).  Note that on Mac, the OptiX library is a universal binary, so we
# only need to look in lib and not lib64 for 64 bit builds.
if(NOT APPLE)
  set(bit_dest "64")
else()
  set(bit_dest "")
endif()

# Helper function: Check to make sure we found what we were looking for
function(OptiX_report_error error_message required component )
  if(DEFINED OptiX_FIND_REQUIRED_${component} AND NOT OptiX_FIND_REQUIRED_${component})
    set(required FALSE)
  endif()
  if(OptiX_FIND_REQUIRED AND required)
    message(FATAL_ERROR "${error_message}  Please locate before proceeding.")
  else()
    if(NOT OptiX_FIND_QUIETLY)
      message(STATUS "${error_message}")
    endif(NOT OptiX_FIND_QUIETLY)
  endif()
endfunction()


foreach(install_dir IN LISTS install_dir_list)
    if(DEFINED OptiX_INCLUDE AND NOT OptiX_INCLUDE)
        message(STATUS "Trying to find Optix in: ${OPTIX_INSTALL_DIR}")
        # Include
        find_path(OptiX_INCLUDE
          NAMES optix.h
          PATHS "${install_dir}/include"
          NO_DEFAULT_PATH
          )
        find_path(OptiX_INCLUDE
          NAMES optix.h
          )
    else()
        continue()
    endif()
endforeach()


if(NOT OptiX_INCLUDE)
    OptiX_report_error("OptiX headers (optix.h and friends) not found." TRUE headers )
else()
    message(STATUS "Optix headers found in: ${OptiX_INCLUDE}")
endif()
