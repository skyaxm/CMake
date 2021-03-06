include(Compiler/Intel)
__compiler_intel(CXX)

string(APPEND CMAKE_CXX_FLAGS_MINSIZEREL_INIT " -DNDEBUG")
string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT " -DNDEBUG")
string(APPEND CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT " -DNDEBUG")

set(CMAKE_DEPFILE_FLAGS_CXX "-MD -MT <OBJECT> -MF <DEPFILE>")

if("x${CMAKE_CXX_SIMULATE_ID}" STREQUAL "xMSVC")
  set(_std -Qstd)
  set(_ext c++)
  if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 16.0)
    set(CMAKE_CXX14_STANDARD_COMPILE_OPTION "-Qstd=c++14")
    # todo: there is no gnu++14 value supported; figure out what to do
    set(CMAKE_CXX14_EXTENSION_COMPILE_OPTION "-Qstd=c++14")
  endif()
else()
  set(_std -std)
  set(_ext gnu++)
  if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.0.2)
    set(CMAKE_CXX14_STANDARD_COMPILE_OPTION "-std=c++14")
    # todo: there is no gnu++14 value supported; figure out what to do
    set(CMAKE_CXX14_EXTENSION_COMPILE_OPTION "-std=c++14")
  elseif (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.0.0)
    set(CMAKE_CXX14_STANDARD_COMPILE_OPTION "-std=c++1y")
    # todo: there is no gnu++14 value supported; figure out what to do
    set(CMAKE_CXX14_EXTENSION_COMPILE_OPTION "-std=c++1y")
  endif()
endif()

if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 13.0)
  set(CMAKE_CXX11_STANDARD_COMPILE_OPTION "${_std}=c++11")
  set(CMAKE_CXX11_EXTENSION_COMPILE_OPTION "${_std}=${_ext}11")
elseif (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 12.1)
  set(CMAKE_CXX11_STANDARD_COMPILE_OPTION "${_std}=c++0x")
  set(CMAKE_CXX11_EXTENSION_COMPILE_OPTION "${_std}=${_ext}0x")
endif()

if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 12.1)
  if("x${CMAKE_CXX_SIMULATE_ID}" STREQUAL "xMSVC")
    set(CMAKE_CXX98_STANDARD_COMPILE_OPTION "")
    set(CMAKE_CXX98_EXTENSION_COMPILE_OPTION "")
  else()
    set(CMAKE_CXX98_STANDARD_COMPILE_OPTION "${_std}=c++98")
    set(CMAKE_CXX98_EXTENSION_COMPILE_OPTION "${_std}=gnu++98")
  endif()
endif()

unset(_std)
unset(_ext)

__compiler_check_default_language_standard(CXX 12.1 98)

macro(cmake_record_cxx_compile_features)
  set(_result 0)
  if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 12.1)
    if (_result EQUAL 0 AND
        (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 16.0
         OR (NOT "x${CMAKE_CXX_SIMULATE_ID}" STREQUAL "xMSVC" AND
             NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.0)))
      _record_compiler_features_cxx(14)
    endif()
    if (_result EQUAL 0)
      _record_compiler_features_cxx(11)
    endif()
    if (_result EQUAL 0)
      _record_compiler_features_cxx(98)
    endif()
  endif()
endmacro()

set(CMAKE_CXX_CREATE_PREPROCESSED_SOURCE "<CMAKE_CXX_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
set(CMAKE_CXX_CREATE_ASSEMBLY_SOURCE "<CMAKE_CXX_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -S <SOURCE> -o <ASSEMBLY_SOURCE>")
