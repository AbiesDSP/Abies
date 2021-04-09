# Add testbench interface. Include verilator root and verilated dir.
add_library(dfb SHARED ${CMAKE_CURRENT_LIST_DIR}/dfb.cpp)
message(STATUS "Add src library: dfb")

# Create trace directories when libraries are built
add_custom_command(TARGET dfb
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/dfb
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/dfb")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/audio_b.sv")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/dfb.sv")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/dfb_tb.sv")

message(STATUS "Verilating dfb using dfb_tb.sv as top")

verilate(dfb TRACE
    TOP_MODULE dfb_tb
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VDfb
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(dfb PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(dfb PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to util libraries.
target_link_libraries(dfb PUBLIC testbench)

# Tests
add_library(test_dfb ${CMAKE_CURRENT_LIST_DIR}/test_dfb.cpp)
target_include_directories(test_dfb PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_dfb PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_dfb PUBLIC dfb CppUTest CppUTestExt)
