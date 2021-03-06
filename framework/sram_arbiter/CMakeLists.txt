# Add the tb interface library. Include verilator root and vinclude dir.
add_library(sram_arbiter SHARED ${CMAKE_CURRENT_LIST_DIR}/sram_arbiter.cpp)
message(STATUS "Add framework library: sram_arbiter")

# Create trace directories when libraries are built
add_custom_command(TARGET sram_arbiter
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/sram_arbiter
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/sram_arbiter")

message(STATUS "Verilating sram_arbiter using sram_arbiter.v as top")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/sram_arbiter_tb.v")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/sram_arbiter.v")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/sram_model.v")

verilate(sram_arbiter TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VSramArbiter
    VERILATOR_ARGS -Gsram_init="${CMAKE_SOURCE_DIR}/mem/sin_w8_d19.coe"
)
# For source modules
target_include_directories(sram_arbiter PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(sram_arbiter PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to utility lib by default.
target_link_libraries(sram_arbiter PUBLIC testbench)

# Tests
add_library(test_sram_arbiter ${CMAKE_CURRENT_LIST_DIR}/test_sram_arbiter.cpp)
target_include_directories(test_sram_arbiter PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_sram_arbiter PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_sram_arbiter PUBLIC sram_arbiter CppUTest CppUTestExt)
