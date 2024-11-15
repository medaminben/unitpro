cmake_minimum_required(VERSION 3.29)

# Project names are only relevant for humans, camel case is Oay
project(UnitPro VERSION 1.3.0)
# globalization of the root project name
set(CMAKE_ROOT_NAME ${PROJECT_NAME})

# In productive projects, often used shared libraries which shortens build time
# when building incrementally, since less files have to be rewritten when a
# library has to be rebuilt.
# This option is the standard option
option(BUILD_SHARED_LIBS     "Build project libraries as shared libraries" ON) 
option(BUILD_APPS            "Build applications"                          ON)
option(BUILD_QT_UI           "Build Qt based applications"                 ON)
option(BUILD_VERBOSE_OUTPUT  "Build with verbose output"                   ON)  
option(BUILD_TESTING         "Build tests"                                 ON)   

# Let include() find modules with out an explicit directory 
# and without a suffix:
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# include modules
include(Common)

# add libraries
# list here the librarries name wanted to be generated 
# is advised to generate first your library from the
# template first and then adapte the structure to your needs
set(libraries_list ) # <---- add your libraries here 

# define here where you want to store your generated libraries and their bound apps
set(libraries_dir     ${CMAKE_SOURCE_DIR}/libraries)
set(applications_dir  ${CMAKE_SOURCE_DIR}/applications)
# to give more freedom you can create your own template structur in a separate folder
set(template_dir  ${CMAKE_SOURCE_DIR}/cmake/template)

generate_libraries(LIBRARIES_LIST     ${libraries_list} 
                   LIBRARIES_LOCATION ${libraries_dir} 
                   APPS_LOCATION      ${applications_dir}
                   TEMPLATE_LOCATION  ${template_dir}
                   )
####################################

if (EXISTS "${libraries_dir}/CMakeLists.txt")
    add_subdirectory(${libraries_dir})
endif()
# add librariy consumers
if(BUILD_APPS)
    if (EXISTS "${applications_dir}/CMakeLists.txt")
     add_subdirectory(${applications_dir})
    endif()
endif()

if(BUILD_VERBOSE_OUTPUT)
    dump_cmake_vars(BuildLogEnd.log)
endif()