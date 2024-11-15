set(VAR_MARKER_START  [[${]]) 
set(VAR_MARKER_END })
# it iterates through the LIBRARIES_LIST in the LIBRARIES_LOCATION path, if the folder 
# doesn't exist then a library boilerplate will be generated using the 
# configuration template in TEMPLATE_LOCATION
function(generate_libraries)
    #parsing arguments
    set(options)
    set(single_value_args LIBRARIES_LOCATION APPS_LOCATION TEMPLATE_LOCATION)
    set(list_args LIBRARIES_LIST )

    cmake_parse_arguments( PARSE_ARGV 0 lib "${options}" "${single_value_args}" "${list_args}")
    foreach(arg IN LISTS lib_UNPARSED_ARGUMENTS)
        message(" >>>>>> unparsed argumemnt: ${arg}")
    endforeach()
    ############################################################
    #call guard
    if(NOT DEFINED lib_LIBRARIES_LOCATION OR lib_LIBRARIES_LOCATION STREQUAL "")
        message(STATUS " >>>>>> generate_libraries missing libraries location.")
        return()
    endif()
    if(NOT DEFINED lib_TEMPLATE_LOCATION OR lib_TEMPLATE_LOCATION STREQUAL "")
        message(STATUS " >>>>>> generate_libraries  missing template location.")
        return()
    endif()
    ############################################################

    foreach(item IN LISTS lib_LIBRARIES_LIST)
        if(IS_DIRECTORY ${lib_LIBRARIES_LOCATION}/${item})
            message(STATUS "::> ${item} found")
            continue()          
        endif()

        message(STATUS "::> generating ${item}")
        if(NOT DEFINED lib_APPS_LOCATION OR lib_APPS_LOCATION STREQUAL "")
            generate_library(NAME        ${item}
                             DESTINATION ${lib_LIBRARIES_LOCATION} 
                             ROOT_NAME   ${CMAKE_ROOT_NAME}
                             CFG_SRC     ${lib_TEMPLATE_LOCATION})
        else()
            generate_library(NAME        ${item}
                             DESTINATION ${lib_LIBRARIES_LOCATION} 
                             ROOT_NAME   ${CMAKE_ROOT_NAME}
                             APPS_DIR    ${lib_APPS_LOCATION}
                             CFG_SRC     ${lib_TEMPLATE_LOCATION})
        endif()
       
    endforeach()
endfunction()


function(generate_library)
    #parsing arguments
    set(options)
    set(list_args)
    set(single_value_args NAME DESTINATION ROOT_NAME APPS_DIR CFG_SRC)
    cmake_parse_arguments(PARSE_ARGV 0 lib "${options}" "${single_value_args}" "${list_args}" )
    
    foreach(arg IN LISTS lib_UNPARSED_ARGUMENTS)
        message(WARNING " >>>>>> unparsed argumemnt: ${arg}")
    endforeach()
    ############################################################
    # call guard
    if(NOT DEFINED lib_NAME OR lib_NAME STREQUAL "")
        return()
    endif()

    set(lib_DIR ${lib_DESTINATION}/${lib_NAME})
    if(IS_DIRECTORY "${lib_DIR}")
        message(STATUS "::> ${lib_NAME} found")
        return()
    endif()
    
    if(NOT DEFINED lib_ROOT_NAME OR lib_ROOT_NAME STREQUAL "")
        set(lib_ROOT_NAME Alten)
        message(WARNING " >>>>>> ${lib_NAME} is missing a root project name \"ROOT_NAME\" but it's needed, \nso it set to derfault value Alten")
    endif()

    
    ############################################################
    # generate library 
    #set paths
    set(lib_include_DIR ${lib_DIR}/include/${lib_ROOT_NAME}/${lib_NAME})
    set(lib_source_DIR  ${lib_DIR}/src)
    set(lib_test_DIR    ${lib_DIR}/test)
    set(lib_gen_DIR     ${lib_CFG_SRC}/lib)

    string(TOUPPER ${lib_ROOT_NAME} lib_ROOT_NAME_UPPER )
    string(TOUPPER ${lib_NAME}      lib_NAME_UPPER )
    # configure an CMakeList file for the library
    configure_file(${lib_gen_DIR}/lib_CMakeLists.txt.in  ${lib_DIR}/CMakeLists.txt)
    configure_file(${lib_gen_DIR}/lib.h.in               ${lib_include_DIR}/${lib_NAME}.h)
    configure_file(${lib_gen_DIR}/lib.cpp.in             ${lib_source_DIR}/${lib_NAME}.cpp)
    configure_file(${lib_gen_DIR}/lib_impl.h.in          ${lib_source_DIR}/${lib_NAME}_impl.h)
    configure_file(${lib_gen_DIR}/lib_impl.cpp.in        ${lib_source_DIR}/${lib_NAME}_impl.cpp)
    configure_file(${lib_gen_DIR}/test_lib.cpp.in        ${lib_test_DIR}/src/test_${lib_NAME}.cpp)
    #create a dummy data file useful for testing 
    file(WRITE ${lib_test_DIR}/data/${lib_NAME}TestData.txt "")

    # Check if the CMakeFileLists doesn't exist the create one 
    if (NOT EXISTS ${lib_DESTINATION}/CMakeLists.txt)
        file(WRITE ${lib_DESTINATION}/CMakeLists.txt "")
    endif()
    # Append the library directory to the CMakeLists file
    file(APPEND ${lib_DESTINATION}/CMakeLists.txt "\nadd_subdirectory(${lib_NAME})")
    ############################################################
    message( "...${lib_NAME} generated")
    ############################################################
    if(NOT DEFINED lib_APPS_DIR OR lib_APPS_DIR STREQUAL "")
       return()
    endif()
    # generate sample app
    message(STATUS "::> generating apps for ${lib_NAME}")

    set(apps_gen_DIR ${lib_CFG_SRC}/app)
    string(TOUPPER   ${lib_ROOT_NAME} lib_ROOT_NAME_UPPER )
    string(TOUPPER   ${lib_NAME}      lib_NAME_UPPER )

    if (NOT EXISTS ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt)
        file(WRITE ${lib_APPS_DIR}/${lib_NAME}//CMakeLists.txt "")
    endif()
    # Append the console app directory to the CMakeLists file
    file(APPEND ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt "\nadd_subdirectory(${lib_NAME}_Console)")

    configure_file(${lib_CFG_SRC}/app/lib_console_CMakeLists.txt.in 
                    ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Console/CMakeLists.txt)

    configure_file(${lib_CFG_SRC}/app/lib_Console.cpp.in            
                    ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Console/${lib_NAME}_Console.cpp)


    if(Qt${QT_VERSION_MAJOR}_FOUND)
        if (NOT EXISTS ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt)
            file(WRITE ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt "")
        endif()
        # Append the console app directory to the CMakeLists file
        file(APPEND ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt "\nadd_subdirectory(${lib_NAME}_Qt_UI)")

        configure_file(${lib_CFG_SRC}/app/lib_qt_ui_CMakeLists.txt.in   
                       ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/CMakeLists.txt)

        configure_file(${lib_CFG_SRC}/app/lib_Qt_UI.cpp.in              
                       ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/${lib_NAME}_Qt_UI.cpp)

        configure_file(${lib_CFG_SRC}/app/lib_mainwindow.cpp.in         
                       ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/mainwindow.cpp)

        configure_file(${lib_CFG_SRC}/app/lib_mainwindow.h.in          
                       ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/mainwindow.h)

        configure_file(${lib_CFG_SRC}/app/lib_mainwindow.ui.in          
                       ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/mainwindow.ui)
    endif()

    # Check if the CMakeFileLists doesn't exist the create one 
    if (NOT EXISTS ${lib_APPS_DIR}/CMakeLists.txt)
        file(WRITE ${lib_APPS_DIR}/CMakeLists.txt "")
    endif()
    # Append the library directory to the CMakeLists file
    file(APPEND ${lib_APPS_DIR}/CMakeLists.txt "\nadd_subdirectory(${lib_NAME})")
endfunction()
