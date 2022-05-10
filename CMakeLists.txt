set(CMAKE_CXX_COMPILER "/usr/local/Cellar/llvm@12/12.0.1_1/bin/clang++")
set(CMAKE_CXX_COMPILER_VERSION "12.0")
set(CMAKE_CXX_STANDARD 20)

cmake_minimum_required(VERSION 3.21)
project(nihongo_anki_tetsudai)


include_directories(src)

include(./build/conan_paths.cmake)
include(./build/conanbuildinfo.cmake)
include(./build/FindCURL.cmake)
include(./build/FindCurses.cmake)
include_directories(${CMAKE_MODULE_PATH})


conan_basic_setup(TARGET)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.yaml ./bin COPYONLY)

# Libraries

set(HEADER_FILES src/lib/dict-parsers/JishoParser.h src/lib/core/Cache.h src/lib/core/VocabCard.h src/lib/util/Conversion.h src/lib/anki/VocabCardAdapter.h)
add_library(nihongo_anki_tetsudai-lib src/lib/dict-parsers/JishoParser.cpp src/lib/core/Cache.cpp ${HEADER_FILES} src/lib/util/Lexic.h src/lib/dict-parsers/TanoshiiJapanese.h src/lib/dict-parsers/TanoshiiJapanese.cpp)
target_include_directories(nihongo_anki_tetsudai-lib PRIVATE src/lib)

#Exec

add_executable(nihongo_anki_tetsudai src/main.cpp ${HEADER_FILES} src/lib/util/HTTP.h)
target_include_directories(nihongo_anki_tetsudai PRIVATE src/lib)

target_link_libraries(nihongo_anki_tetsudai nihongo_anki_tetsudai-lib yaml-cpp curl CURL::libcurl tidy fmt xml2 iconv ncurses ${ncurses_COMPONENTS} ${TARGETS})
