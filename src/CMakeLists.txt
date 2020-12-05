set(TRACE_DIR ${CMAKE_BINARY_DIR}/traces/${MODULE_GROUP})

# All include paths and calls needed to create a "testbench"
function(add_vmodule_tb MODULE_GROUP TB_NAME VMOD_NAME VFILE_NAME VARGS)
    # Add est Library. Include verilator root and vinclude dir.
    add_library(${TB_NAME} SHARED ${CMAKE_SOURCE_DIR}/src/${MODULE_GROUP}/${TB_NAME}.cpp)
    message(STATUS "Add library: ${TB_NAME}")

    # Create trace directories when libraries are built
    set(TRACE_DIR traces/${MODULE_GROUP})
    add_custom_command(TARGET ${TB_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/${TRACE_DIR}
        COMMENT "Creating ${MODULE_GROUP} trace directory: ${TRACE_DIR}...")

    message(STATUS "Verilating ${TB_NAME} using ${VFILE_NAME} with parameters: ${VARGS}")
    verilate(${TB_NAME} COVERAGE TRACE
        INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/src/${MODULE_GROUP}
        SOURCES ${CMAKE_SOURCE_DIR}/src/${MODULE_GROUP}/${VFILE_NAME}
        DIRECTORY ${CMAKE_BINARY_DIR}/vinclude
        PREFIX ${VMOD_NAME}
        VERILATOR_ARGS ${VARGS}
    )
    # For source modules
    target_include_directories(${TB_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/src)
    target_include_directories(${TB_NAME} PUBLIC ${CMAKE_BINARY_DIR}/vinclude)
    # Link to testbench lib by default.
    target_link_libraries(${TB_NAME} PUBLIC VTestbench)
endfunction()

# Add all libraries here.
add_vmodule_tb(Counter CounterTb VCounter counter.v "")
add_vmodule_tb(Counter Counter8Tb VCounter8 counter.v "-GCOUNTER_SIZE=8")
