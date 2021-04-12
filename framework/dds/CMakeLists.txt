# Tests
add_library(test_dds test_dds.cpp)
target_include_directories(test_dds PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_dds PRIVATE CppUTest CppUTestExt)

# Link to utility libs.
target_link_libraries(test_dds PUBLIC testbench)

message(STATUS "Verilating dds using dds.sv as top")
set(V_SRCS "")
list(APPEND V_SRCS "dds.sv")

verilate(test_dds TRACE
    TOP_MODULE dds
    # INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VDds
    VERILATOR_ARGS -GWFM_FILE="${CMAKE_SOURCE_DIR}/mem/sin_w24_d10.mem"
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_dds
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/dds
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/dds")
