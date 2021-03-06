

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


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findyaml-cpp.cmake")
# Global approach
set(yaml-cpp_FOUND 1)
set(yaml-cpp_VERSION "0.7.0")

find_package_handle_standard_args(yaml-cpp REQUIRED_VARS
                                  yaml-cpp_VERSION VERSION_VAR yaml-cpp_VERSION)
mark_as_advanced(yaml-cpp_FOUND yaml-cpp_VERSION)


set(yaml-cpp_INCLUDE_DIRS "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/include")
set(yaml-cpp_INCLUDE_DIR "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/include")
set(yaml-cpp_INCLUDES "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/include")
set(yaml-cpp_RES_DIRS )
set(yaml-cpp_DEFINITIONS )
set(yaml-cpp_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(yaml-cpp_COMPILE_DEFINITIONS )
set(yaml-cpp_COMPILE_OPTIONS_LIST "" "")
set(yaml-cpp_COMPILE_OPTIONS_C "")
set(yaml-cpp_COMPILE_OPTIONS_CXX "")
set(yaml-cpp_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(yaml-cpp_LIBRARIES "") # Will be filled later
set(yaml-cpp_LIBS "") # Same as yaml-cpp_LIBRARIES
set(yaml-cpp_SYSTEM_LIBS )
set(yaml-cpp_FRAMEWORK_DIRS )
set(yaml-cpp_FRAMEWORKS )
set(yaml-cpp_FRAMEWORKS_FOUND "") # Will be filled later
set(yaml-cpp_BUILD_MODULES_PATHS "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/lib/cmake/conan-official-yaml-cpp-targets.cmake")

conan_find_apple_frameworks(yaml-cpp_FRAMEWORKS_FOUND "${yaml-cpp_FRAMEWORKS}" "${yaml-cpp_FRAMEWORK_DIRS}")

mark_as_advanced(yaml-cpp_INCLUDE_DIRS
                 yaml-cpp_INCLUDE_DIR
                 yaml-cpp_INCLUDES
                 yaml-cpp_DEFINITIONS
                 yaml-cpp_LINKER_FLAGS_LIST
                 yaml-cpp_COMPILE_DEFINITIONS
                 yaml-cpp_COMPILE_OPTIONS_LIST
                 yaml-cpp_LIBRARIES
                 yaml-cpp_LIBS
                 yaml-cpp_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to yaml-cpp_LIBS and yaml-cpp_LIBRARY_LIST
set(yaml-cpp_LIBRARY_LIST yaml-cpp)
set(yaml-cpp_LIB_DIRS "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_yaml-cpp_DEPENDENCIES "${yaml-cpp_FRAMEWORKS_FOUND} ${yaml-cpp_SYSTEM_LIBS} ")

conan_package_library_targets("${yaml-cpp_LIBRARY_LIST}"  # libraries
                              "${yaml-cpp_LIB_DIRS}"      # package_libdir
                              "${_yaml-cpp_DEPENDENCIES}"  # deps
                              yaml-cpp_LIBRARIES            # out_libraries
                              yaml-cpp_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "yaml-cpp")                                      # package_name

set(yaml-cpp_LIBS ${yaml-cpp_LIBRARIES})

foreach(_FRAMEWORK ${yaml-cpp_FRAMEWORKS_FOUND})
    list(APPEND yaml-cpp_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND yaml-cpp_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${yaml-cpp_SYSTEM_LIBS})
    list(APPEND yaml-cpp_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND yaml-cpp_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(yaml-cpp_LIBRARIES_TARGETS "${yaml-cpp_LIBRARIES_TARGETS};")
set(yaml-cpp_LIBRARIES "${yaml-cpp_LIBRARIES};")

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/yaml-cpp/0.7.0/_/_/package/6a83d7f783e7ee89a83cf2fe72b5f5f67538e2a6/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET yaml-cpp::yaml-cpp)
        add_library(yaml-cpp::yaml-cpp INTERFACE IMPORTED)
        if(yaml-cpp_INCLUDE_DIRS)
            set_target_properties(yaml-cpp::yaml-cpp PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${yaml-cpp_INCLUDE_DIRS}")
        endif()
        set_property(TARGET yaml-cpp::yaml-cpp PROPERTY INTERFACE_LINK_LIBRARIES
                     "${yaml-cpp_LIBRARIES_TARGETS};${yaml-cpp_LINKER_FLAGS_LIST}")
        set_property(TARGET yaml-cpp::yaml-cpp PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${yaml-cpp_COMPILE_DEFINITIONS})
        set_property(TARGET yaml-cpp::yaml-cpp PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${yaml-cpp_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${yaml-cpp_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
