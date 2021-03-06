# Add the tb interface library. Include verilator root and vinclude dir.
add_library(counter SHARED ${CMAKE_CURRENT_LIST_DIR}/counter.cpp)
message(STATUS "Add framework library: counter")

# Create trace directories when libraries are built
add_custom_command(TARGET counter
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/counter
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/counter")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/counter.v")

verilate(counter TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VCounter
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(counter PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(counter PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to utility lib by default.
target_link_libraries(counter PUBLIC testbench)

# Tests
add_library(test_counter ${CMAKE_CURRENT_LIST_DIR}/test_counter.cpp)
target_include_directories(test_counter PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_counter PRIVATE ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_counter PRIVATE counter CppUTest CppUTestExt)
