cmake_minimum_required(VERSION 3.10)
project(abies)

# Locate verilator
find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
    message(FATAL_ERROR "Verilator not found. Install Verilator, or set VERILATOR_ROOT environment variable in ~/.bashrc")
else()
    message(STATUS "Using Verilator found in $ENV{VERILATOR_ROOT}")
endif()

# Locate CppUTest
if (DEFINED ENV{CPPUTEST_HOME})
    message(STATUS "Using CppUTest found in $ENV{CPPUTEST_HOME}")
else()
    message(FATAL_ERROR "CPPUTEST_HOME is not set. Set CPPUTEST_HOME in ~/.bashrc")
    return()
endif()

# find_package(OpenGL REQUIRED)
# find_package(GLUT REQUIRED)
# add_executable(dumbplot util/dumbplot.cpp)
# # target_include_directories(dumbplot ${OPENGL_INCLUDE_DIRS} ${GLUT_INCLUDE_DIRS})
# target_link_libraries(dumbplot PRIVATE ${OPENGL_gl_LIBRARY} ${GLUT_LIBRARIES})


add_subdirectory(util)
add_subdirectory(framework)
add_subdirectory(abies-lib)
add_subdirectory(tests)
