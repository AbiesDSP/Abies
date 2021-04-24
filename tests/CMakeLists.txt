# Verilate and create tests.
macro(VModule top mod_name test_name vargs)
    # Tests
    add_library(${test_name} ${test_name}.cpp)
    target_include_directories(${test_name} PRIVATE ${VERILATOR_ROOT}/include)
    target_link_libraries(${test_name} PRIVATE CppUTest CppUTestExt ${UTIL_LIBS} ${MODEL_LIBS})

    # Main Test Runner
    target_link_libraries(run_all_tests PRIVATE ${test_name})

    # Verilated libraries.
    verilate(${test_name} TRACE
        TOP_MODULE ${top}
        INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
        SOURCES ${CMAKE_SOURCE_DIR}/framework/${top}.sv
        DIRECTORY ${CMAKE_BINARY_DIR}/verilated
        PREFIX ${mod_name}
        VERILATOR_ARGS ${vargs}
    )

    # Create trace directories when libraries are built
    add_custom_command(TARGET ${test_name}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/${top}
        COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/${top}")
endmacro()

find_package(CppUTest REQUIRED)

# 
set(UTIL_LIBS
    co_sim
    testbench
)
set(MODEL_LIBS
    sram
)

# Main test runner.
add_executable(run_all_tests run_all_tests.cpp)
target_include_directories(run_all_tests PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(run_all_tests PRIVATE CppUTest CppUTestExt)

VModule(abies_top VAbiesTop test_abies_top -GWFM_FILE="${CMAKE_SOURCE_DIR}/mem/sin_w24_d10.mem")
# VModule(dds VDds test_dds -GWFM_FILE="${CMAKE_SOURCE_DIR}/mem/sin_w24_d10.mem")
# VModule(i2s_tb VI2S test_i2s "")
# VModule(sram_arbiter VSramArbiter test_sram_arbiter "")
# VModule(fir VFir test_fir -GCOEF_FILE="${CMAKE_SOURCE_DIR}/mem/fir_bp_21.mem")
# VModule(fifo VFifo test_fifo "")
# VModule(pwm VPwm test_pwm "")
VModule(cobs_encode VCobsEncode test_cobs_encode "")
VModule(cobs_decode VCobsDecode test_cobs_decode "")
VModule(uart VUart test_uart "")
