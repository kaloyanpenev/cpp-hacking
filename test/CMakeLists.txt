add_executable(example_test example_test.cpp)
target_link_libraries(example_test PRIVATE order_engine_warnings)

add_test(NAME example_test COMMAND example_test)
