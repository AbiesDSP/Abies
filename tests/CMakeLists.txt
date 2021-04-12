# Main test runner.
add_executable(run_all_tests ${CMAKE_SOURCE_DIR}/tests/run_all_tests.cpp)
target_include_directories(run_all_tests PRIVATE ${VERILATOR_ROOT}/include)

# Link all test groups
target_link_libraries(run_all_tests PRIVATE test_sram_arbiter)
target_link_libraries(run_all_tests PRIVATE test_pwm)
target_link_libraries(run_all_tests PRIVATE test_dds)
target_link_libraries(run_all_tests PRIVATE test_fir)
target_link_libraries(run_all_tests PRIVATE test_i2sm_tx)
target_link_libraries(run_all_tests PRIVATE test_fifo)
target_link_libraries(run_all_tests PRIVATE test_dfb)
