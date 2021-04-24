cmake_minimum_required(VERSION 3.10)
project(abies)

# Locate verilator
find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
    message(FATAL_ERROR "Verilator not found. Install Verilator, or set VERILATOR_ROOT environment variable in ~/.bashrc")
else()
    message(STATUS "Using Verilator found in $ENV{VERILATOR_ROOT}")
endif()

add_subdirectory(util)
add_subdirectory(models)
add_subdirectory(tests)
# add_subdirectory(abies-lib)
