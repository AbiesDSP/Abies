# Add the tb interface library. Include verilator root and vinclude dir.
add_library(buffer SHARED ${CMAKE_CURRENT_LIST_DIR}/buffer.cpp)
message(STATUS "Add framework library: buffer")

# Create trace directories when libraries are built
add_custom_command(TARGET buffer
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/buffer
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/buffer")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/buffer.v")

verilate(buffer TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VBuffer
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(buffer PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(buffer PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to utility lib by default.
target_link_libraries(buffer PUBLIC testbench)

# Tests
add_library(test_buffer ${CMAKE_CURRENT_LIST_DIR}/test_buffer.cpp)
target_include_directories(test_buffer PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_buffer PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_buffer PUBLIC buffer CppUTest CppUTestExt)
