# Tests
add_library(test_sram_arbiter test_sram_arbiter.cpp)
target_include_directories(test_sram_arbiter PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_sram_arbiter PUBLIC CppUTest CppUTestExt)

# Link to utility libs.
target_link_libraries(test_sram_arbiter PUBLIC testbench)
target_link_libraries(test_sram_arbiter PUBLIC sram)

message(STATUS "Verilating sram_arbiter using sram_arbiter.v as top")
set(V_SRCS "")
list(APPEND V_SRCS "sram_arbiter.sv")

verilate(test_sram_arbiter TRACE
    TOP_MODULE sram_arbiter
    # INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VSramArbiter
    VERILATOR_ARGS
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_sram_arbiter
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/sram_arbiter
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/sram_arbiter")
