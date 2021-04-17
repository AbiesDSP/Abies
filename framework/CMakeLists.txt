add_subdirectory(abies_top)
# add_subdirectory(sram_arbiter)
# add_subdirectory(pwm)
# add_subdirectory(fir)
add_subdirectory(i2s)
# add_subdirectory(fifo)
# add_subdirectory(dds)
# add_subdirectory(dfb)

find_package(CppUTest REQUIRED)

# Main test runner.
add_executable(run_all_tests run_all_tests.cpp)
target_include_directories(run_all_tests PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(run_all_tests PRIVATE CppUTest CppUTestExt)

target_link_libraries(run_all_tests PRIVATE
    test_abies_top
    # test_sram_arbiter
    # test_pwm
    # test_fir
    test_i2s_tx
    # test_fifo
    # test_dds
    # test_dfb
)
