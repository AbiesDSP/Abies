# Add testbench interface. Include verilator root and verilated dir.
add_library(fifo SHARED ${CMAKE_CURRENT_LIST_DIR}/fifo.cpp)
message(STATUS "Add src library: fifo")

# Create trace directories when libraries are built
add_custom_command(TARGET fifo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/fifo
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/fifo")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/fifo.sv")

message(STATUS "Verilating fifo using fifo.sv as top")

verilate(fifo TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VFifo
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(fifo PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(fifo PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to util libraries by default.
set(UTIL_LIBS "")
list(APPEND UTIL_LIBS testbench)
target_link_libraries(fifo PUBLIC ${UTIL_LIBS})

# Tests
add_library(test_fifo ${CMAKE_CURRENT_LIST_DIR}/test_fifo.cpp)
target_include_directories(test_fifo PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_fifo PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_fifo PUBLIC fifo CppUTest CppUTestExt)
