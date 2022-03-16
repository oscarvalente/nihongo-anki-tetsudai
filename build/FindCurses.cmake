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

conan_message(STATUS "Conan: Using autogenerated FindCurses.cmake")
set(Curses_FOUND 1)
set(Curses_VERSION "6.3")

find_package_handle_standard_args(Curses REQUIRED_VARS
                                  Curses_VERSION VERSION_VAR Curses_VERSION)
mark_as_advanced(Curses_FOUND Curses_VERSION)

set(ncurses_COMPONENTS ncurses::panel ncurses::menu ncurses::form ncurses::curses++ ncurses::ticlib ncurses::libcurses ncurses::tinfo)

if(Curses_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${Curses_FIND_COMPONENTS})
        list(FIND ncurses_COMPONENTS "ncurses::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'ncurses'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'ncurses'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(ncurses_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include;/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_DEFINITIONS "-DNCURSES_STATIC")
set(ncurses_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(ncurses_COMPILE_DEFINITIONS "NCURSES_STATIC")
set(ncurses_COMPILE_OPTIONS_LIST "" "")
set(ncurses_COMPILE_OPTIONS_C "")
set(ncurses_COMPILE_OPTIONS_CXX "")
set(ncurses_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(ncurses_LIBRARIES "") # Will be filled later
set(ncurses_LIBS "") # Same as ncurses_LIBRARIES
set(ncurses_SYSTEM_LIBS )
set(ncurses_FRAMEWORK_DIRS )
set(ncurses_FRAMEWORKS )
set(ncurses_FRAMEWORKS_FOUND "") # Will be filled later
set(ncurses_BUILD_MODULES_PATHS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib/cmake/conan-official-ncurses-targets.cmake")

conan_find_apple_frameworks(ncurses_FRAMEWORKS_FOUND "${ncurses_FRAMEWORKS}" "${ncurses_FRAMEWORK_DIRS}")

mark_as_advanced(ncurses_INCLUDE_DIRS
                 ncurses_INCLUDE_DIR
                 ncurses_INCLUDES
                 ncurses_DEFINITIONS
                 ncurses_LINKER_FLAGS_LIST
                 ncurses_COMPILE_DEFINITIONS
                 ncurses_COMPILE_OPTIONS_LIST
                 ncurses_LIBRARIES
                 ncurses_LIBS
                 ncurses_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to ncurses_LIBS and ncurses_LIBRARY_LIST
set(ncurses_LIBRARY_LIST panelw menuw formw ncurses++w ticw ncursesw tinfow)
set(ncurses_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_ncurses_DEPENDENCIES "${ncurses_FRAMEWORKS_FOUND} ${ncurses_SYSTEM_LIBS} ")

conan_package_library_targets("${ncurses_LIBRARY_LIST}"  # libraries
                              "${ncurses_LIB_DIRS}"      # package_libdir
                              "${_ncurses_DEPENDENCIES}"  # deps
                              ncurses_LIBRARIES            # out_libraries
                              ncurses_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "ncurses")                                      # package_name

set(ncurses_LIBS ${ncurses_LIBRARIES})

foreach(_FRAMEWORK ${ncurses_FRAMEWORKS_FOUND})
    list(APPEND ncurses_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND ncurses_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${ncurses_SYSTEM_LIBS})
    list(APPEND ncurses_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND ncurses_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(ncurses_LIBRARIES_TARGETS "${ncurses_LIBRARIES_TARGETS};")
set(ncurses_LIBRARIES "${ncurses_LIBRARIES};")

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib/cmake" ${CMAKE_PREFIX_PATH})


########### COMPONENT tinfo VARIABLES #############################################

set(ncurses_tinfo_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_tinfo_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include;/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_tinfo_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_tinfo_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_tinfo_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_tinfo_DEFINITIONS )
set(ncurses_tinfo_COMPILE_DEFINITIONS )
set(ncurses_tinfo_COMPILE_OPTIONS_C "")
set(ncurses_tinfo_COMPILE_OPTIONS_CXX "")
set(ncurses_tinfo_LIBS tinfow)
set(ncurses_tinfo_SYSTEM_LIBS )
set(ncurses_tinfo_FRAMEWORK_DIRS )
set(ncurses_tinfo_FRAMEWORKS )
set(ncurses_tinfo_BUILD_MODULES_PATHS )
set(ncurses_tinfo_DEPENDENCIES )
set(ncurses_tinfo_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT libcurses VARIABLES #############################################

set(ncurses_libcurses_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_libcurses_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include;/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_libcurses_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include/ncursesw")
set(ncurses_libcurses_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_libcurses_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_libcurses_DEFINITIONS "-DNCURSES_STATIC")
set(ncurses_libcurses_COMPILE_DEFINITIONS "NCURSES_STATIC")
set(ncurses_libcurses_COMPILE_OPTIONS_C "")
set(ncurses_libcurses_COMPILE_OPTIONS_CXX "")
set(ncurses_libcurses_LIBS ncursesw)
set(ncurses_libcurses_SYSTEM_LIBS )
set(ncurses_libcurses_FRAMEWORK_DIRS )
set(ncurses_libcurses_FRAMEWORKS )
set(ncurses_libcurses_BUILD_MODULES_PATHS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib/cmake/conan-official-ncurses-targets.cmake")
set(ncurses_libcurses_DEPENDENCIES ncurses::tinfo)
set(ncurses_libcurses_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT ticlib VARIABLES #############################################

set(ncurses_ticlib_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_ticlib_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_ticlib_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_ticlib_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_ticlib_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_ticlib_DEFINITIONS )
set(ncurses_ticlib_COMPILE_DEFINITIONS )
set(ncurses_ticlib_COMPILE_OPTIONS_C "")
set(ncurses_ticlib_COMPILE_OPTIONS_CXX "")
set(ncurses_ticlib_LIBS ticw)
set(ncurses_ticlib_SYSTEM_LIBS )
set(ncurses_ticlib_FRAMEWORK_DIRS )
set(ncurses_ticlib_FRAMEWORKS )
set(ncurses_ticlib_BUILD_MODULES_PATHS )
set(ncurses_ticlib_DEPENDENCIES ncurses::libcurses)
set(ncurses_ticlib_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT curses++ VARIABLES #############################################

set(ncurses_curses++_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_curses++_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_curses++_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_curses++_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_curses++_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_curses++_DEFINITIONS )
set(ncurses_curses++_COMPILE_DEFINITIONS )
set(ncurses_curses++_COMPILE_OPTIONS_C "")
set(ncurses_curses++_COMPILE_OPTIONS_CXX "")
set(ncurses_curses++_LIBS ncurses++w)
set(ncurses_curses++_SYSTEM_LIBS )
set(ncurses_curses++_FRAMEWORK_DIRS )
set(ncurses_curses++_FRAMEWORKS )
set(ncurses_curses++_BUILD_MODULES_PATHS )
set(ncurses_curses++_DEPENDENCIES ncurses::libcurses)
set(ncurses_curses++_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT form VARIABLES #############################################

set(ncurses_form_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_form_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_form_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_form_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_form_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_form_DEFINITIONS )
set(ncurses_form_COMPILE_DEFINITIONS )
set(ncurses_form_COMPILE_OPTIONS_C "")
set(ncurses_form_COMPILE_OPTIONS_CXX "")
set(ncurses_form_LIBS formw)
set(ncurses_form_SYSTEM_LIBS )
set(ncurses_form_FRAMEWORK_DIRS )
set(ncurses_form_FRAMEWORKS )
set(ncurses_form_BUILD_MODULES_PATHS )
set(ncurses_form_DEPENDENCIES ncurses::libcurses)
set(ncurses_form_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT menu VARIABLES #############################################

set(ncurses_menu_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_menu_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_menu_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_menu_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_menu_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_menu_DEFINITIONS )
set(ncurses_menu_COMPILE_DEFINITIONS )
set(ncurses_menu_COMPILE_OPTIONS_C "")
set(ncurses_menu_COMPILE_OPTIONS_CXX "")
set(ncurses_menu_LIBS menuw)
set(ncurses_menu_SYSTEM_LIBS )
set(ncurses_menu_FRAMEWORK_DIRS )
set(ncurses_menu_FRAMEWORKS )
set(ncurses_menu_BUILD_MODULES_PATHS )
set(ncurses_menu_DEPENDENCIES ncurses::libcurses)
set(ncurses_menu_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT panel VARIABLES #############################################

set(ncurses_panel_INCLUDE_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_panel_INCLUDE_DIR "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_panel_INCLUDES "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/include")
set(ncurses_panel_LIB_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib")
set(ncurses_panel_RES_DIRS "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/res")
set(ncurses_panel_DEFINITIONS )
set(ncurses_panel_COMPILE_DEFINITIONS )
set(ncurses_panel_COMPILE_OPTIONS_C "")
set(ncurses_panel_COMPILE_OPTIONS_CXX "")
set(ncurses_panel_LIBS panelw)
set(ncurses_panel_SYSTEM_LIBS )
set(ncurses_panel_FRAMEWORK_DIRS )
set(ncurses_panel_FRAMEWORKS )
set(ncurses_panel_BUILD_MODULES_PATHS )
set(ncurses_panel_DEPENDENCIES ncurses::libcurses)
set(ncurses_panel_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT tinfo FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_tinfo_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_tinfo_FRAMEWORKS_FOUND "${ncurses_tinfo_FRAMEWORKS}" "${ncurses_tinfo_FRAMEWORK_DIRS}")

set(ncurses_tinfo_LIB_TARGETS "")
set(ncurses_tinfo_NOT_USED "")
set(ncurses_tinfo_LIBS_FRAMEWORKS_DEPS ${ncurses_tinfo_FRAMEWORKS_FOUND} ${ncurses_tinfo_SYSTEM_LIBS} ${ncurses_tinfo_DEPENDENCIES})
conan_package_library_targets("${ncurses_tinfo_LIBS}"
                              "${ncurses_tinfo_LIB_DIRS}"
                              "${ncurses_tinfo_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_tinfo_NOT_USED
                              ncurses_tinfo_LIB_TARGETS
                              ""
                              "ncurses_tinfo")

set(ncurses_tinfo_LINK_LIBS ${ncurses_tinfo_LIB_TARGETS} ${ncurses_tinfo_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_PREFIX_PATH})

########## COMPONENT libcurses FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_libcurses_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_libcurses_FRAMEWORKS_FOUND "${ncurses_libcurses_FRAMEWORKS}" "${ncurses_libcurses_FRAMEWORK_DIRS}")

set(ncurses_libcurses_LIB_TARGETS "")
set(ncurses_libcurses_NOT_USED "")
set(ncurses_libcurses_LIBS_FRAMEWORKS_DEPS ${ncurses_libcurses_FRAMEWORKS_FOUND} ${ncurses_libcurses_SYSTEM_LIBS} ${ncurses_libcurses_DEPENDENCIES})
conan_package_library_targets("${ncurses_libcurses_LIBS}"
                              "${ncurses_libcurses_LIB_DIRS}"
                              "${ncurses_libcurses_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_libcurses_NOT_USED
                              ncurses_libcurses_LIB_TARGETS
                              ""
                              "ncurses_libcurses")

set(ncurses_libcurses_LINK_LIBS ${ncurses_libcurses_LIB_TARGETS} ${ncurses_libcurses_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/"
			"/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/lib/cmake" ${CMAKE_PREFIX_PATH})

########## COMPONENT ticlib FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_ticlib_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_ticlib_FRAMEWORKS_FOUND "${ncurses_ticlib_FRAMEWORKS}" "${ncurses_ticlib_FRAMEWORK_DIRS}")

set(ncurses_ticlib_LIB_TARGETS "")
set(ncurses_ticlib_NOT_USED "")
set(ncurses_ticlib_LIBS_FRAMEWORKS_DEPS ${ncurses_ticlib_FRAMEWORKS_FOUND} ${ncurses_ticlib_SYSTEM_LIBS} ${ncurses_ticlib_DEPENDENCIES})
conan_package_library_targets("${ncurses_ticlib_LIBS}"
                              "${ncurses_ticlib_LIB_DIRS}"
                              "${ncurses_ticlib_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_ticlib_NOT_USED
                              ncurses_ticlib_LIB_TARGETS
                              ""
                              "ncurses_ticlib")

set(ncurses_ticlib_LINK_LIBS ${ncurses_ticlib_LIB_TARGETS} ${ncurses_ticlib_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_PREFIX_PATH})

########## COMPONENT curses++ FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_curses++_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_curses++_FRAMEWORKS_FOUND "${ncurses_curses++_FRAMEWORKS}" "${ncurses_curses++_FRAMEWORK_DIRS}")

set(ncurses_curses++_LIB_TARGETS "")
set(ncurses_curses++_NOT_USED "")
set(ncurses_curses++_LIBS_FRAMEWORKS_DEPS ${ncurses_curses++_FRAMEWORKS_FOUND} ${ncurses_curses++_SYSTEM_LIBS} ${ncurses_curses++_DEPENDENCIES})
conan_package_library_targets("${ncurses_curses++_LIBS}"
                              "${ncurses_curses++_LIB_DIRS}"
                              "${ncurses_curses++_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_curses++_NOT_USED
                              ncurses_curses++_LIB_TARGETS
                              ""
                              "ncurses_curses++")

set(ncurses_curses++_LINK_LIBS ${ncurses_curses++_LIB_TARGETS} ${ncurses_curses++_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_PREFIX_PATH})

########## COMPONENT form FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_form_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_form_FRAMEWORKS_FOUND "${ncurses_form_FRAMEWORKS}" "${ncurses_form_FRAMEWORK_DIRS}")

set(ncurses_form_LIB_TARGETS "")
set(ncurses_form_NOT_USED "")
set(ncurses_form_LIBS_FRAMEWORKS_DEPS ${ncurses_form_FRAMEWORKS_FOUND} ${ncurses_form_SYSTEM_LIBS} ${ncurses_form_DEPENDENCIES})
conan_package_library_targets("${ncurses_form_LIBS}"
                              "${ncurses_form_LIB_DIRS}"
                              "${ncurses_form_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_form_NOT_USED
                              ncurses_form_LIB_TARGETS
                              ""
                              "ncurses_form")

set(ncurses_form_LINK_LIBS ${ncurses_form_LIB_TARGETS} ${ncurses_form_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_PREFIX_PATH})

########## COMPONENT menu FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_menu_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_menu_FRAMEWORKS_FOUND "${ncurses_menu_FRAMEWORKS}" "${ncurses_menu_FRAMEWORK_DIRS}")

set(ncurses_menu_LIB_TARGETS "")
set(ncurses_menu_NOT_USED "")
set(ncurses_menu_LIBS_FRAMEWORKS_DEPS ${ncurses_menu_FRAMEWORKS_FOUND} ${ncurses_menu_SYSTEM_LIBS} ${ncurses_menu_DEPENDENCIES})
conan_package_library_targets("${ncurses_menu_LIBS}"
                              "${ncurses_menu_LIB_DIRS}"
                              "${ncurses_menu_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_menu_NOT_USED
                              ncurses_menu_LIB_TARGETS
                              ""
                              "ncurses_menu")

set(ncurses_menu_LINK_LIBS ${ncurses_menu_LIB_TARGETS} ${ncurses_menu_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_PREFIX_PATH})

########## COMPONENT panel FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(ncurses_panel_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(ncurses_panel_FRAMEWORKS_FOUND "${ncurses_panel_FRAMEWORKS}" "${ncurses_panel_FRAMEWORK_DIRS}")

set(ncurses_panel_LIB_TARGETS "")
set(ncurses_panel_NOT_USED "")
set(ncurses_panel_LIBS_FRAMEWORKS_DEPS ${ncurses_panel_FRAMEWORKS_FOUND} ${ncurses_panel_SYSTEM_LIBS} ${ncurses_panel_DEPENDENCIES})
conan_package_library_targets("${ncurses_panel_LIBS}"
                              "${ncurses_panel_LIB_DIRS}"
                              "${ncurses_panel_LIBS_FRAMEWORKS_DEPS}"
                              ncurses_panel_NOT_USED
                              ncurses_panel_LIB_TARGETS
                              ""
                              "ncurses_panel")

set(ncurses_panel_LINK_LIBS ${ncurses_panel_LIB_TARGETS} ${ncurses_panel_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/Users/valenteo/.conan/data/ncurses/6.3/_/_/package/a422dad32b13c1008074a7b788c19a6cfbf09f8e/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT tinfo TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::tinfo)
        add_library(ncurses::tinfo INTERFACE IMPORTED)
        set_target_properties(ncurses::tinfo PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_tinfo_INCLUDE_DIRS}")
        set_target_properties(ncurses::tinfo PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_tinfo_LIB_DIRS}")
        set_target_properties(ncurses::tinfo PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_tinfo_LINK_LIBS};${ncurses_tinfo_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::tinfo PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_tinfo_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::tinfo PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_tinfo_COMPILE_OPTIONS_C};${ncurses_tinfo_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT libcurses TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::libcurses)
        add_library(ncurses::libcurses INTERFACE IMPORTED)
        set_target_properties(ncurses::libcurses PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_libcurses_INCLUDE_DIRS}")
        set_target_properties(ncurses::libcurses PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_libcurses_LIB_DIRS}")
        set_target_properties(ncurses::libcurses PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_libcurses_LINK_LIBS};${ncurses_libcurses_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::libcurses PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_libcurses_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::libcurses PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_libcurses_COMPILE_OPTIONS_C};${ncurses_libcurses_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT ticlib TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::ticlib)
        add_library(ncurses::ticlib INTERFACE IMPORTED)
        set_target_properties(ncurses::ticlib PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_ticlib_INCLUDE_DIRS}")
        set_target_properties(ncurses::ticlib PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_ticlib_LIB_DIRS}")
        set_target_properties(ncurses::ticlib PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_ticlib_LINK_LIBS};${ncurses_ticlib_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::ticlib PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_ticlib_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::ticlib PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_ticlib_COMPILE_OPTIONS_C};${ncurses_ticlib_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT curses++ TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::curses++)
        add_library(ncurses::curses++ INTERFACE IMPORTED)
        set_target_properties(ncurses::curses++ PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_curses++_INCLUDE_DIRS}")
        set_target_properties(ncurses::curses++ PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_curses++_LIB_DIRS}")
        set_target_properties(ncurses::curses++ PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_curses++_LINK_LIBS};${ncurses_curses++_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::curses++ PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_curses++_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::curses++ PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_curses++_COMPILE_OPTIONS_C};${ncurses_curses++_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT form TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::form)
        add_library(ncurses::form INTERFACE IMPORTED)
        set_target_properties(ncurses::form PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_form_INCLUDE_DIRS}")
        set_target_properties(ncurses::form PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_form_LIB_DIRS}")
        set_target_properties(ncurses::form PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_form_LINK_LIBS};${ncurses_form_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::form PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_form_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::form PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_form_COMPILE_OPTIONS_C};${ncurses_form_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT menu TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::menu)
        add_library(ncurses::menu INTERFACE IMPORTED)
        set_target_properties(ncurses::menu PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_menu_INCLUDE_DIRS}")
        set_target_properties(ncurses::menu PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_menu_LIB_DIRS}")
        set_target_properties(ncurses::menu PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_menu_LINK_LIBS};${ncurses_menu_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::menu PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_menu_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::menu PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_menu_COMPILE_OPTIONS_C};${ncurses_menu_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT panel TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ncurses::panel)
        add_library(ncurses::panel INTERFACE IMPORTED)
        set_target_properties(ncurses::panel PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${ncurses_panel_INCLUDE_DIRS}")
        set_target_properties(ncurses::panel PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${ncurses_panel_LIB_DIRS}")
        set_target_properties(ncurses::panel PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${ncurses_panel_LINK_LIBS};${ncurses_panel_LINKER_FLAGS_LIST}")
        set_target_properties(ncurses::panel PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${ncurses_panel_COMPILE_DEFINITIONS}")
        set_target_properties(ncurses::panel PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${ncurses_panel_COMPILE_OPTIONS_C};${ncurses_panel_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET ncurses::ncurses)
        add_library(ncurses::ncurses INTERFACE IMPORTED)
    endif()
    set_property(TARGET ncurses::ncurses APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${ncurses_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT tinfo BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_tinfo_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT libcurses BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_libcurses_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT ticlib BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_ticlib_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT curses++ BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_curses++_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT form BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_form_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT menu BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_menu_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT panel BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${ncurses_panel_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()