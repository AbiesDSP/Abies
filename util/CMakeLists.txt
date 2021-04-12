# External co-simulations
add_library(cosim INTERFACE)
target_include_directories(cosim INTERFACE ${CMAKE_CURRENT_LIST_DIR})

add_library(testbench INTERFACE)
target_include_directories(testbench INTERFACE ${VERILATOR_ROOT}/include)
target_include_directories(testbench INTERFACE ${CMAKE_CURRENT_LIST_DIR})
