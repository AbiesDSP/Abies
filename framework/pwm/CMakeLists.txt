add_library(pwm SHARED ${CMAKE_CURRENT_LIST_DIR}/pwm.cpp)
message(STATUS "Add framework library: pwm")

# Create trace directories when libraries are built
add_custom_command(TARGET pwm
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/pwm
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/pwm")

message(STATUS "Verilating pwm using pwm.v")

set(SRAM_SRCS "")
list(APPEND SRAM_SRCS "${CMAKE_CURRENT_LIST_DIR}/pwm.v")

verilate(pwm TRACE
    INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}
    SOURCES ${SRAM_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/verilated
    PREFIX VPwm
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(pwm PUBLIC ${CMAKE_SOURCE_DIR}/framework)
target_include_directories(pwm PUBLIC ${CMAKE_BINARY_DIR}/verilated)
# Link to testbench lib by default.
target_link_libraries(pwm PUBLIC testbench)

# Tests
add_library(test_pwm ${CMAKE_CURRENT_LIST_DIR}/test_pwm.cpp)
target_include_directories(test_pwm PRIVATE ${VERILATOR_ROOT}/include)
target_include_directories(test_pwm PRIVATE ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(test_pwm PRIVATE pwm CppUTest CppUTestExt)


