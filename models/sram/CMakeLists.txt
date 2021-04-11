# SRAM Model Library
add_library(sram sram.cpp)
target_include_directories(sram PUBLIC ${CMAKE_CURRENT_LIST_DIR})
target_link_libraries(sram PUBLIC cosim)
