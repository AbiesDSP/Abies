# counter_tb
add_library(CounterTest ${CMAKE_SOURCE_DIR}/tests/CounterTest.cpp)
target_link_libraries(CounterTest PRIVATE CounterTb Counter8Tb)

# Main test runner.
add_executable(RunAllTests ${CMAKE_SOURCE_DIR}/tests/RunAllTests.cpp)
target_include_directories(RunAllTests PRIVATE ${VERILATOR_ROOT}/include)

# Link test runners here.
target_link_libraries(RunAllTests PRIVATE CounterTest)

# Link to CppUTest Libraries.
target_link_libraries(RunAllTests PRIVATE CppUTest CppUTestExt)
