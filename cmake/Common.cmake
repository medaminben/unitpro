# common utilities for CMake,
# Include this file as early as possible 
# in the top CMakeLists.txt

# Use C++ 17 at least for nested  
# namespaces and other new features 
set(CMAKE_CXX_STANDARD 20)

# some custom functions and macros
include(BuildUtils)
include(libraryGenerator)  
# Standard settings for build and import locations:
include(BuildLocation)

if(BUILD_VERBOSE_OUTPUT)
    include(DebugUtils)
    set(CMAKE_VERBOSE_MAKEFILE ON)
    dump_cmake_vars(configLogStart.log)
endif()

if(CMAKE_COMPILER_IS_GNUCXX 
    OR CMAKE_CXX_COMPILER_ID MATCHES Clang)
    # Activate all warnings 
    # and consider warnings as errors
    set(CMAKE_C_FLAGS 
        "${CMAKE_CXX_FLAGS} -Wall -Werror"
    )
    set(CMAKE_CXX_FLAGS 
        "${CMAKE_CXX_FLAGS} -Wall -Werror"
    )
endif()

if(UNIX)
    execute_process( COMMAND ping www.google.com -c 2 OUTPUT_QUIET RESULT_VARIABLE NO_CONNECTION)
else()
    execute_process(COMMAND ping www.google.com -n 2 OUTPUT_QUIET RESULT_VARIABLE NO_CONNECTION )
endif()

if(NO_CONNECTION EQUAL 0)
    set(FETCHCONTENT_FULLY_DISCONNECTED OFF)
    message("Fetch online mode... ")   
else()
    set(FETCHCONTENT_FULLY_DISCONNECTED ON)
    message("Fetch offline mode: no intenet connection requires already populated _deps to build properly!" )
endif()

if(BUILD_TESTING)
    print(BUILD_TESTING)
    include(CTest)
    enable_testing()
    include(TestUtils)
endif()

if(BUILD_QT_UI)
    include(QtSupport)
endif()

if(BUILD_VERBOSE_OUTPUT)
    dump_cmake_vars(configLogEnd.log)
endif()
