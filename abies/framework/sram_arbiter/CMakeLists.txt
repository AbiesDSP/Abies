# Add est Library. Include verilator root and vinclude dir.
message("Current List Dir: ${CMAKE_CURRENT_LIST_DIR}")

add_library(sram_arbiter SHARED ${CMAKE_SOURCE_DIR}/framework/sram_arbiter/sram_arbiter.cpp)
message(STATUS "Add framework library: sram_arbiter")

# Create trace directories when libraries are built
add_custom_command(TARGET sram_arbiter
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/sram_arbiter
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/sram_arbiter")

message(STATUS "Verilating sram_arbiter using sram_arbiter_tb.v as top")

set(SRAM_SRCS "")
list(APPEND SRAM_SRCS "${CMAKE_SOURCE_DIR}/framework/sram_arbiter/sram_arbiter_tb.v")
list(APPEND SRAM_SRCS "${CMAKE_SOURCE_DIR}/framework/sram_arbiter/sram_arbiter.v")
list(APPEND SRAM_SRCS "${CMAKE_SOURCE_DIR}/framework/sram_arbiter/sram_model.v")

verilate(sram_arbiter COVERAGE TRACE
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework/sram_arbiter
    SOURCES ${SRAM_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/vinclude
    PREFIX VSramArbiter
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(sram_arbiter PUBLIC ${CMAKE_SOURCE_DIR}/framework)
target_include_directories(sram_arbiter PUBLIC ${CMAKE_BINARY_DIR}/vinclude)
# Link to testbench lib by default.
target_link_libraries(sram_arbiter PUBLIC testbench)
