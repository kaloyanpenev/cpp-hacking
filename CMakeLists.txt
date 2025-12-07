cmake_minimum_required(VERSION 3.21)

project(order_engine LANGUAGES CXX VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(WARNING_MESSAGE WARNING)

option(ENABLE_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" ON)
option(ENABLE_IPO "Enable IPO/LTO when supported" ON)
option(ENABLE_ASAN "Enable address sanitizer" ON)
option(ENABLE_CLANG_TIDY "Run clang-tidy during builds" ON)
option(ENABLE_CPPCHECK "Run cppcheck during builds" ON)
option(ENABLE_IWYU "Run include-what-you-use during builds" OFF)

include(cmake/CompilerWarnings.cmake)
include(cmake/InterproceduralOptimization.cmake)
include(cmake/StaticAnalyzers.cmake)

add_library(order_engine_warnings INTERFACE)
myproject_set_project_warnings(
  order_engine_warnings
  ${ENABLE_WARNINGS_AS_ERRORS}
  "" "" "" "")

if(ENABLE_IPO)
  myproject_enable_ipo()
endif()

if(ENABLE_ASAN AND CMAKE_CXX_COMPILER_ID MATCHES ".*Clang|GNU")
  add_compile_options(-fsanitize=address -fno-omit-frame-pointer)
  add_link_options(-fsanitize=address)
endif()

add_executable(order_engine src/main.cpp)
target_link_libraries(order_engine PRIVATE order_engine_warnings)

if(ENABLE_CLANG_TIDY)
  myproject_enable_clang_tidy(order_engine_warnings ${ENABLE_WARNINGS_AS_ERRORS})
endif()

if(ENABLE_CPPCHECK)
  myproject_enable_cppcheck(${ENABLE_WARNINGS_AS_ERRORS} "")
endif()

if(ENABLE_IWYU)
  myproject_enable_include_what_you_use()
endif()

include(CTest)
if(BUILD_TESTING)
  add_subdirectory(test)
endif()
