# Tests
add_library(test_fir test_fir.cpp)
target_include_directories(test_fir PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_fir PRIVATE CppUTest CppUTestExt)

# Utility libraries
target_link_libraries(test_fir PUBLIC testbench)

set(V_SRCS "")
list(APPEND V_SRCS "fir.sv")
message(STATUS "Verilating fir using fir.sv as top")

verilate(test_fir TRACE
    TOP_MODULE fir
    # INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VFir
    VERILATOR_ARGS -GCOEF_FILE="${CMAKE_SOURCE_DIR}/mem/fir_bp_21.mem"
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_fir
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/fir
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/fir")
