# Tests
add_library(test_i2s_tx test_i2s_tx.cpp)
target_include_directories(test_i2s_tx PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_i2s_tx PRIVATE CppUTest CppUTestExt)

# Utility Libraries
target_link_libraries(test_i2s_tx PUBLIC testbench)

set(V_SRCS "")
list(APPEND V_SRCS "i2s_tx.sv")
message(STATUS "Verilating i2s_tx using i2s_tx.sv as top")

verilate(test_i2s_tx TRACE
    TOP_MODULE i2s_tx
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VI2STx
    VERILATOR_ARGS ""
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_i2s_tx
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/i2s_tx
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/i2s_tx")
