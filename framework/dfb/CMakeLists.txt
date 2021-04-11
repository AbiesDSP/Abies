# Tests
add_library(test_dfb test_dfb.cpp)
target_include_directories(test_dfb PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_dfb PRIVATE CppUTest CppUTestExt)

# Link Utility Libraries
target_link_libraries(test_dfb PRIVATE testbench)
target_link_libraries(test_dfb PRIVATE sram)

# Verilog sources
set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/dfb.sv")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/dfb_tb.sv")
message(STATUS "Verilating dfb using dfb_tb.sv as top")

verilate(test_dfb TRACE
    TOP_MODULE dfb_tb
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VDfb
    VERILATOR_ARGS ""
)
# Create trace directories when libraries are built
add_custom_command(TARGET test_dfb
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/dfb
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/dfb")
