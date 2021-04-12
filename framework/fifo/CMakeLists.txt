# Tests
add_library(test_fifo test_fifo.cpp)
target_include_directories(test_fifo PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_fifo PUBLIC CppUTest CppUTestExt)

# Link to utility libs
target_link_libraries(test_fifo PUBLIC testbench)

message(STATUS "Verilating fifo using fifo.sv as top")
set(V_SRCS "")
list(APPEND V_SRCS "fifo.sv")

verilate(test_fifo TRACE
    TOP_MODULE fifo
    # INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VFifo
    VERILATOR_ARGS ""
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_fifo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/fifo
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/fifo")
