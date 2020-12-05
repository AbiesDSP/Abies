add_library(VTestbench INTERFACE)
target_include_directories(VTestbench INTERFACE ${VERILATOR_ROOT}/include)
target_include_directories(VTestbench INTERFACE ${CMAKE_SOURCE_DIR}/util)
