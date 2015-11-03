


#########################################################################
# Control whether libraries are shared or static.
if( MSVC )
option(IDYNTREE_SHARED_LIBRARY "Compile iDynTree as a shared library" FALSE)
else()
option(IDYNTREE_SHARED_LIBRARY "Compile iDynTree as a shared library" TRUE)
endif()
set(BUILD_SHARED_LIBS ${IDYNTREE_SHARED_LIBRARY})


#########################################################################
# Use position indipendent code
set (CMAKE_POSITION_INDEPENDENT_CODE TRUE)

#########################################################################
# Turn on testing.
option(IDYNTREE_COMPILE_TESTS "Compile iDynTree tests" FALSE)
if(IDYNTREE_COMPILE_TESTS)
   include( CTest )
   enable_testing()

   # adding support for checking the tests with valgrind
    find_package(Valgrind QUIET)
    if(VALGRIND_FOUND)
        set(CTEST_MEMORYCHECK_COMMAND ${VALGRIND_PROGRAM})
        set(MEMORYCHECK_COMMAND_OPTIONS "--leak-check=full --error-exitcode=1"  CACHE STRING "Options to pass to the memory checker")
        mark_as_advanced(MEMORYCHECK_COMMAND_OPTIONS)
    endif()
endif()

#########################################################################
# Turn on bindings compilation.
option(IDYNTREE_COMPILE_BINDINGS "Compile iDynTree bindings" FALSE)

#########################################################################
# Turn on compilation of geometrical relations semantics check.
option(IDYNTREE_USES_SEMANTICS "Compile iDynTree semantics check" FALSE)

#########################################################################
# Deal with RPATH
option(IDYNTREE_ENABLE_RPATH "Enable RPATH for the library" TRUE)
mark_as_advanced(IDYNTREE_ENABLE_RPATH)

#########################################################################
# Enable/disable dependencies

option(IDYNTREE_ENABLE_SYMORO_PAR "Enable support for SyMoRo par format" TRUE)
option(IDYNTREE_USES_KDL "Compile iDynTree with KDL dependency" TRUE)
option(IDYNTREE_USES_YARP "Compile iDynTree with YARP dependency" TRUE)
option(IDYNTREE_USES_ICUB_MAIN  "Compiled iDynTree with icub-main dependencies (for iKin and skinDynLib helper functions and tools)" TRUE)
if( MSVC )
option(IDYNTREE_USES_INTERNAL_URDFDOM "Compile iDynTree with an internal copy of urdfdom patched to avoid Boost dependencies" TRUE)
else()
option(IDYNTREE_USES_INTERNAL_URDFDOM "Compile iDynTree with an internal copy of urdfdom patched to avoid Boost dependencies" FALSE)
endif()

if(IDYNTREE_USES_INTERNAL_URDFDOM)
    add_definitions(-DURDF_USE_PLAIN_POINTERS)
    add_definitions(-DIDYNTREE_USE_INTERNAL_URDFDOM)
endif()

if(MSVC)
    set(CMAKE_DEBUG_POSTFIX "d")
endif(MSVC)

# Compile flags definitions for Semantic checks
if(IDYNTREE_COMPILE_BINDINGS)
    add_definitions(-DIDYNTREE_COMPILE_BINDINGS)
endif(IDYNTREE_COMPILE_BINDINGS)

if(IDYNTREE_USES_SEMANTICS)
    add_definitions(-DIDYNTREE_USES_SEMANTICS)
endif(IDYNTREE_USES_SEMANTICS)

#set default build type to "Release" in single-config generators
if(NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Choose the type of build, recommanded options are: Debug or Release" FORCE)
    endif()
    set(IDYNTREE_BUILD_TYPES "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${IDYNTREE_BUILD_TYPES})
endif()

# Include ECM Sanitizers, for enable compilation support of GCC and Clang
# sanitizers. Imported from http://api.kde.org/ecm/module/ECMEnableSanitizers.html
include(ECMEnableSanitizers)

# Enable warnings on Debug builds
if(MSVC)
    ###
else()
    ##Other systems
    if(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
        SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Weverything -pedantic -Wnon-virtual-dtor -Woverloaded-virtual")
        #disable padding alignment warnings. Cast align is more subtle. On X86 it should not create any problem but for different architecture we should handle this warning better.
        SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-padded -Wno-cast-align")
        if (CODYCO_TRAVIS_CI)
            #disable documentation warnings and sign comparison. This is for Travis-CI
            MESSAGE(STATUS "Disabling some warning for Travis-CI")
            SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-documentation -Wno-documentation-unknown-command -Wno-sign-conversion")
        endif()
        MESSAGE(STATUS "Clang compiler - Debug configuration flags: -Weverything -pedantic -Wnon-virtual-dtor -Woverloaded-virtual")
    elseif(${CMAKE_COMPILER_IS_GNUCC})
        SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra")
        if (NOT CODYCO_TRAVIS_CI)
            MESSAGE(STATUS "Gcc compiler - Debug configuration flags: -Wall -Wextra -pedantic -Weffc++ -Woverloaded-virtual")
            SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -pedantic -Weffc++ -Woverloaded-virtual")
        endif()
    endif()
endif()
