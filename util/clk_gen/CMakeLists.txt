#
add_library(clk_gen SHARED clk_gen.cpp)
target_include_directories(clk_gen PUBLIC ${CMAKE_CURRENT_LIST_DIR})
