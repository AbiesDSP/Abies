add_library(testbench INTERFACE)
target_include_directories(testbench INTERFACE ${VERILATOR_ROOT}/include)
target_include_directories(testbench INTERFACE ${CMAKE_CURRENT_LIST_DIR})

target_link_libraries(testbench INTERFACE co_sim)
