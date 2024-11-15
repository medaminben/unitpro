
include(GTestSupport)
# build_gtest_executable
# Thin layer above standard CMake standard support providing utility
# functions.
#
# Use DISCOVER if you want CMake to discover the tests in the
# executable automatically with gtest_discover_tests()
#
# add_gtest_executable(NAME test_library_name
#     SRC
#         test_file1.cpp
#         test_file2.cpp
#     DEPENDS
#         Some::Libs
#     DISCOVER
#         [ON/OFF]
# )

function(build_gtest_executable)
    #parsing arguments
    set(options)
    set(single_value_args NAME DISCOVER)
    set(list_args SRC DEPENDS)
    cmake_parse_arguments( PARSE_ARGV 0 test "${options}" "${single_value_args}" "${list_args}")
    foreach(arg IN LISTS lib_UNPARSED_ARGUMENTS)
        message(" >>>>>> unparsed argumemnt: ${arg}")
    endforeach()
    ############################################################
    # call guard
    if(NOT "${test_NAME}" MATCHES "test_.*")
        message(FATAL_ERROR "> ${test_NAME} : for management restriction the executable name should start with test_")
    endif()

    if("${test_NAME}" MATCHES ".*[A-Z].*")
        message(FATAL_ERROR "> ${test_NAME}: for management restriction the executable name should start name be lowercase")
    endif()

    if ("${test_SRC}" STREQUAL "")
        message(FATAL_ERROR "> ${test_NAME}: missing source files for test executable")
    endif()
    ############################################################
    # build test
    add_executable(${test_NAME} ${test_SRC})
    target_link_libraries(${test_NAME} PUBLIC ${test_DEPENDS})    
 
    if(${test_DISCOVER})
        gtest_discover_tests(${test_NAME})
    endif()

endfunction()