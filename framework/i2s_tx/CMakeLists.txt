# Add testbench interface. Include verilator root and verilated dir.
add_library(i2s_tx SHARED ${CMAKE_CURRENT_LIST_DIR}/i2s_tx.cpp)
message(STATUS "Add src library: i2s_tx")

# Create trace directories when libraries are built
add_custom_command(TARGET i2s_tx
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/i2s_tx
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/i2s_tx")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/i2s_tx.v")

message(STATUS "Verilating i2s_tx using i2s_tx.v as top")

verilate(i2s_tx TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VI2STx
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(i2s_tx PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(i2s_tx PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to util libraries by default.
set(UTIL_LIBS "")
list(APPEND UTIL_LIBS testbench)
target_link_libraries(i2s_tx PUBLIC ${UTIL_LIBS})

# Tests
add_library(test_i2s_tx ${CMAKE_CURRENT_LIST_DIR}/test_i2s_tx.cpp)
target_include_directories(test_i2s_tx PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_i2s_tx PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_i2s_tx PUBLIC i2s_tx CppUTest CppUTestExt)
