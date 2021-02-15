# Add est Library. Include verilator root and vinclude dir.
message("Current List Dir: ${CMAKE_CURRENT_LIST_DIR}")

add_library(pwm SHARED ${CMAKE_SOURCE_DIR}/framework/pwm/pwm.cpp)
message(STATUS "Add framework library: pwm")

# Create trace directories when libraries are built
add_custom_command(TARGET pwm
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/traces/pwm
    COMMENT "Creating trace directory: ${CMAKE_BINARY_DIR}/traces/pwm")

message(STATUS "Verilating pwm using pwm.v")

set(SRAM_SRCS "")
list(APPEND SRAM_SRCS "${CMAKE_SOURCE_DIR}/framework/pwm/pwm.v")

verilate(pwm COVERAGE TRACE
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/framework/pwm
    SOURCES ${SRAM_SRCS}
    DIRECTORY ${CMAKE_BINARY_DIR}/vinclude
    PREFIX VPwm
    VERILATOR_ARGS ""
)
# For source modules
target_include_directories(pwm PUBLIC ${CMAKE_SOURCE_DIR}/framework)
target_include_directories(pwm PUBLIC ${CMAKE_BINARY_DIR}/vinclude)
# Link to testbench lib by default.
target_link_libraries(pwm PUBLIC testbench)

