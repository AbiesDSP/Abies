# Main test runner.
add_executable(run_all_tests ${CMAKE_SOURCE_DIR}/tests/run_all_tests.cpp)
target_include_directories(run_all_tests PRIVATE ${VERILATOR_ROOT}/include)

# List of all test groups that the main test runner will run. Add or remove groups from this list.
set(ALL_TEST_GROUPS "")
list(APPEND ALL_TEST_GROUPS test_pwm)
list(APPEND ALL_TEST_GROUPS test_sram_arbiter)
list(APPEND ALL_TEST_GROUPS test_buffer)
list(APPEND ALL_TEST_GROUPS test_counter)

# Link it.
target_link_libraries(run_all_tests PRIVATE ${ALL_TEST_GROUPS})
# Link to CppUTest Libraries.
target_link_libraries(run_all_tests PRIVATE CppUTest CppUTestExt)
