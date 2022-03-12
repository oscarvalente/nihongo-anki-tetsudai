########## MACROS ###########################################################################
#############################################################################################

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


########### FOUND PACKAGE ###################################################################
#############################################################################################

include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findtidy.cmake")
set(tidy_FOUND 1)
set(tidy_VERSION "5.7.28")

find_package_handle_standard_args(tidy REQUIRED_VARS
                                  tidy_VERSION VERSION_VAR tidy_VERSION)
mark_as_advanced(tidy_FOUND tidy_VERSION)

set(tidy_COMPONENTS tidy::tidy-static)

if(tidy_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${tidy_FIND_COMPONENTS})
        list(FIND tidy_COMPONENTS "tidy::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'tidy'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'tidy'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(tidy_INCLUDE_DIRS "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/include")
set(tidy_INCLUDE_DIR "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/include")
set(tidy_INCLUDES "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/include")
set(tidy_RES_DIRS )
set(tidy_DEFINITIONS "-DTIDY_STATIC")
set(tidy_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(tidy_COMPILE_DEFINITIONS "TIDY_STATIC")
set(tidy_COMPILE_OPTIONS_LIST "" "")
set(tidy_COMPILE_OPTIONS_C "")
set(tidy_COMPILE_OPTIONS_CXX "")
set(tidy_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(tidy_LIBRARIES "") # Will be filled later
set(tidy_LIBS "") # Same as tidy_LIBRARIES
set(tidy_SYSTEM_LIBS )
set(tidy_FRAMEWORK_DIRS )
set(tidy_FRAMEWORKS )
set(tidy_FRAMEWORKS_FOUND "") # Will be filled later
set(tidy_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(tidy_FRAMEWORKS_FOUND "${tidy_FRAMEWORKS}" "${tidy_FRAMEWORK_DIRS}")

mark_as_advanced(tidy_INCLUDE_DIRS
                 tidy_INCLUDE_DIR
                 tidy_INCLUDES
                 tidy_DEFINITIONS
                 tidy_LINKER_FLAGS_LIST
                 tidy_COMPILE_DEFINITIONS
                 tidy_COMPILE_OPTIONS_LIST
                 tidy_LIBRARIES
                 tidy_LIBS
                 tidy_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to tidy_LIBS and tidy_LIBRARY_LIST
set(tidy_LIBRARY_LIST tidys)
set(tidy_LIB_DIRS "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_tidy_DEPENDENCIES "${tidy_FRAMEWORKS_FOUND} ${tidy_SYSTEM_LIBS} ")

conan_package_library_targets("${tidy_LIBRARY_LIST}"  # libraries
                              "${tidy_LIB_DIRS}"      # package_libdir
                              "${_tidy_DEPENDENCIES}"  # deps
                              tidy_LIBRARIES            # out_libraries
                              tidy_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "tidy")                                      # package_name

set(tidy_LIBS ${tidy_LIBRARIES})

foreach(_FRAMEWORK ${tidy_FRAMEWORKS_FOUND})
    list(APPEND tidy_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND tidy_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${tidy_SYSTEM_LIBS})
    list(APPEND tidy_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND tidy_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(tidy_LIBRARIES_TARGETS "${tidy_LIBRARIES_TARGETS};")
set(tidy_LIBRARIES "${tidy_LIBRARIES};")

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/" ${CMAKE_PREFIX_PATH})


########### COMPONENT tidy-static VARIABLES #############################################

set(tidy_tidy-static_INCLUDE_DIRS "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/include")
set(tidy_tidy-static_INCLUDE_DIR "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/include")
set(tidy_tidy-static_INCLUDES "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/include")
set(tidy_tidy-static_LIB_DIRS "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/lib")
set(tidy_tidy-static_RES_DIRS )
set(tidy_tidy-static_DEFINITIONS "-DTIDY_STATIC")
set(tidy_tidy-static_COMPILE_DEFINITIONS "TIDY_STATIC")
set(tidy_tidy-static_COMPILE_OPTIONS_C "")
set(tidy_tidy-static_COMPILE_OPTIONS_CXX "")
set(tidy_tidy-static_LIBS tidys)
set(tidy_tidy-static_SYSTEM_LIBS )
set(tidy_tidy-static_FRAMEWORK_DIRS )
set(tidy_tidy-static_FRAMEWORKS )
set(tidy_tidy-static_BUILD_MODULES_PATHS )
set(tidy_tidy-static_DEPENDENCIES )
set(tidy_tidy-static_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT tidy-static FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(tidy_tidy-static_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(tidy_tidy-static_FRAMEWORKS_FOUND "${tidy_tidy-static_FRAMEWORKS}" "${tidy_tidy-static_FRAMEWORK_DIRS}")

set(tidy_tidy-static_LIB_TARGETS "")
set(tidy_tidy-static_NOT_USED "")
set(tidy_tidy-static_LIBS_FRAMEWORKS_DEPS ${tidy_tidy-static_FRAMEWORKS_FOUND} ${tidy_tidy-static_SYSTEM_LIBS} ${tidy_tidy-static_DEPENDENCIES})
conan_package_library_targets("${tidy_tidy-static_LIBS}"
                              "${tidy_tidy-static_LIB_DIRS}"
                              "${tidy_tidy-static_LIBS_FRAMEWORKS_DEPS}"
                              tidy_tidy-static_NOT_USED
                              tidy_tidy-static_LIB_TARGETS
                              ""
                              "tidy_tidy-static")

set(tidy_tidy-static_LINK_LIBS ${tidy_tidy-static_LIB_TARGETS} ${tidy_tidy-static_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/tidy-html5/5.7.28/_/_/package/d2fcd0c654e542053e46571e7da974c338f3c3e5/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT tidy-static TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET tidy::tidy-static)
        add_library(tidy::tidy-static INTERFACE IMPORTED)
        set_target_properties(tidy::tidy-static PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${tidy_tidy-static_INCLUDE_DIRS}")
        set_target_properties(tidy::tidy-static PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${tidy_tidy-static_LIB_DIRS}")
        set_target_properties(tidy::tidy-static PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${tidy_tidy-static_LINK_LIBS};${tidy_tidy-static_LINKER_FLAGS_LIST}")
        set_target_properties(tidy::tidy-static PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${tidy_tidy-static_COMPILE_DEFINITIONS}")
        set_target_properties(tidy::tidy-static PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${tidy_tidy-static_COMPILE_OPTIONS_C};${tidy_tidy-static_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET tidy::tidy)
        add_library(tidy::tidy INTERFACE IMPORTED)
    endif()
    set_property(TARGET tidy::tidy APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${tidy_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT tidy-static BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${tidy_tidy-static_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()