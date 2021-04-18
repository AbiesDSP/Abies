# Tests
add_library(test_abies_top test_abies_top.cpp)
target_include_directories(test_abies_top PRIVATE ${VERILATOR_ROOT}/include)
target_link_libraries(test_abies_top PRIVATE CppUTest CppUTestExt)

# Utility Libraries
target_link_libraries(test_abies_top PUBLIC testbench)

set(V_SRCS "")
list(APPEND V_SRCS "abies_top.sv")
list(APPEND V_SRS "${CMAKE_SOURCE_DIR}/mem/sin_w24_d10.mem")
set(IDIRS "${CMAKE_SOURCE_DIR}/framework")
list(APPEND IDIRS "${CMAKE_SOURCE_DIR}/framework/sram_arbiter")
list(APPEND IDIRS "${CMAKE_SOURCE_DIR}/framework/pwm")
list(APPEND IDIRS "${CMAKE_SOURCE_DIR}/framework/i2s")
list(APPEND IDIRS "${CMAKE_SOURCE_DIR}/framework/dds")

message(STATUS "Verilating abies_top using abies_top.sv as top")

verilate(test_abies_top TRACE
    TOP_MODULE abies_top
    INCLUDE_DIRS ${IDIRS} 
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VAbiesTop
    VERILATOR_ARGS -GWFM_FILE="${CMAKE_SOURCE_DIR}/mem/sin_w24_d10.mem"
)

# Create trace directories when libraries are built
add_custom_command(TARGET test_abies_top
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/abies_top
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/abies_top")
