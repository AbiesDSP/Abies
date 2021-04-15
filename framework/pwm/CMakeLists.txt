# Tests
add_library(test_pwm test_pwm.cpp)
target_include_directories(test_pwm PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_pwm PRIVATE CppUTest CppUTestExt)

# Utility Libraries
target_link_libraries(test_pwm PUBLIC testbench)
target_link_libraries(test_pwm PRIVATE clk_gen)

message(STATUS "Verilating pwm using pwm.sv")
set(V_SRCS "")
list(APPEND V_SRCS "pwm.sv")

verilate(test_pwm TRACE
    TOP_MODULE pwm
    # INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VPwm
    VERILATOR_ARGS ""
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_pwm
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/pwm
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/pwm")
