# Add testbench interface. Include verilator root and verilated dir.
add_library(dds SHARED ${CMAKE_CURRENT_LIST_DIR}/dds.cpp)
message(STATUS "Add src library: dds")

# Create trace directories when libraries are built
add_custom_command(TARGET dds
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/dds
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/dds")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/dds.sv")

message(STATUS "Verilating dds using dds.sv as top")

verilate(dds TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VDds
    VERILATOR_ARGS -GWFM_FILE="${CMAKE_SOURCE_DIR}/mem/sin_w24_d10.mem"
)
# For source modules
target_include_directories(dds PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(dds PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to util libraries by default.
set(UTIL_LIBS "")
list(APPEND UTIL_LIBS testbench)
target_link_libraries(dds PUBLIC ${UTIL_LIBS})

# Tests
add_library(test_dds ${CMAKE_CURRENT_LIST_DIR}/test_dds.cpp)
target_include_directories(test_dds PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_dds PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_dds PUBLIC dds CppUTest CppUTestExt)
