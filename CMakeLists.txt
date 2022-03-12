set(CMAKE_CXX_COMPILER "/usr/local/Cellar/llvm@12/12.0.1_1/bin/clang++")
set(CMAKE_CXX_COMPILER_VERSION "12.0")
set(CMAKE_CXX_STANDARD 20)

cmake_minimum_required(VERSION 3.21)
project(nihongo_anki_tetsudai)


include_directories(src)

include(./build/conan_paths.cmake)
include(./build/conanbuildinfo.cmake)
include(./build/FindCURL.cmake)
include_directories(${CONAN_YAML-CPP_ROOT} ${CONAN_LIBCURL_ROOT} ${CONAN_ZLIB_ROOT} ${CONAN_TIDY-HTML5_ROOT} ${CONAN_FMT_ROOT} ${CONAN_LIBXML2_ROOT} ${CMAKE_MODULE_PATH})
conan_basic_setup(TARGET)


configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.yaml ./bin COPYONLY)

add_executable(nihongo_anki_tetsudai src/main.cpp src/dict-parsers/JishoParser.cpp)

target_link_libraries(nihongo_anki_tetsudai yaml-cpp curl CURL::libcurl tidy fmt xml2 iconv ${TARGETS})
