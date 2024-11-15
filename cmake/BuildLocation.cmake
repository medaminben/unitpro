set(PROJECT_BUILD_OUTPUT              ${CMAKE_SOURCE_DIR}/build)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY   ${PROJECT_BUILD_OUTPUT}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY   ${PROJECT_BUILD_OUTPUT}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY   ${PROJECT_BUILD_OUTPUT}/bin)
if(UNIX)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BUILD_OUTPUT}/lib)  
endif()

# 3rd party location
### Qt framework 
#set(QT6_DIR "C:/Qt/6.7.0/mingw_64/lib/cmake")
