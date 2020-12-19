# Add all tests
function(add_test TEST_GROUP)
    add_library(test_${TEST_GROUP} ${CMAKE_SOURCE_DIR}/tests/test_${TEST_GROUP}.cpp)
    target_link_libraries(test_${TEST_GROUP} PRIVATE ${TEST_GROUP})
    target_link_libraries(run_all_tests PRIVATE test_${TEST_GROUP})
endfunction()

# Main test runner.
add_executable(run_all_tests ${CMAKE_SOURCE_DIR}/tests/run_all_tests.cpp)
target_include_directories(run_all_tests PRIVATE ${VERILATOR_ROOT}/include)

# Link test runners here.
add_test(counter)
add_test(buffer)

# Link to CppUTest Libraries.
target_link_libraries(run_all_tests PRIVATE CppUTest CppUTestExt)
