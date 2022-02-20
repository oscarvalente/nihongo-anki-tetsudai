set(CMAKE_CXX_COMPILER "/usr/local/Cellar/llvm@12/12.0.1_1/bin/clang++")
set(CMAKE_CXX_COMPILER_VERSION "12.0")
set(CMAKE_CXX_STANDARD 20)

cmake_minimum_required(VERSION 3.21)
project(nihongo_anki_tetsudai)


include_directories(src)

include(./build/conan_paths.cmake)
include(./build/conanbuildinfo.cmake)
include_directories(${CONAN_YAML-CPP_ROOT} ${CMAKE_MODULE_PATH})
conan_basic_setup(TARGET)


configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.yaml ./bin COPYONLY)

add_executable(nihongo_anki_tetsudai src/main.cpp)

target_link_libraries(nihongo_anki_tetsudai yaml-cpp ${TARGETS})
