include(FetchContent)

FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
set(gtest_force_shared_crt OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

add_executable(example_test example_test.cpp)
target_link_libraries(example_test PRIVATE order_engine_warnings GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(example_test)
