# Add testbench interface. Include verilator root and verilated dir.
add_library(fir SHARED ${CMAKE_CURRENT_LIST_DIR}/fir.cpp)
message(STATUS "Add src library: fir")

# Create trace directories when libraries are built
add_custom_command(TARGET fir
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/fir
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/fir")

set(V_SRCS "")
list(APPEND V_SRCS "${CMAKE_CURRENT_LIST_DIR}/fir.v")

message(STATUS "Verilating fir using fir.v as top")

verilate(fir TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${V_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VFir
    VERILATOR_ARGS -GCOEF_FILE="${CMAKE_SOURCE_DIR}/mem/fir_bp_21.mem"
)
# For source modules
target_include_directories(fir PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_include_directories(fir PUBLIC ${CMAKE_BINARY_DIR}/verilated)

# Link to util libraries by default.
set(UTIL_LIBS "")
list(APPEND UTIL_LIBS testbench)
target_link_libraries(fir PUBLIC ${UTIL_LIBS})

# Tests
add_library(test_fir ${CMAKE_CURRENT_LIST_DIR}/test_fir.cpp)
target_include_directories(test_fir PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_fir PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_fir PUBLIC fir CppUTest CppUTestExt)
