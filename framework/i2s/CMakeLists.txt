# Tests
add_library(test_i2s test_i2s.cpp)
target_include_directories(test_i2s PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_i2s PRIVATE CppUTest CppUTestExt)

# Utility Libraries
target_link_libraries(test_i2s PUBLIC testbench)

set(V_SRCS "")
list(APPEND V_SRCS "i2s_tx.sv")
list(APPEND V_SRCS "i2s_rx.sv")
list(APPEND V_SRCS "i2s_bi.sv")
list(APPEND V_SRCS "i2s_clkgen.sv")
list(APPEND V_SRCS "i2s_tb.sv")

message(STATUS "Verilating i2s_tx using i2s_tx.sv as top")

verilate(test_i2s TRACE
    TOP_MODULE i2s_tb
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VI2S
    VERILATOR_ARGS ""
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_i2s
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/i2s
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/i2s_tx")
