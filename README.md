# Abies
Open Source, Real Time, Digital Audio Effects Framkework

## Dependencies
- CMake
- Verilator
- CppUTest (Test framework)
- GTKWave (Viewing waveforms)

    Make sure these are installed and their env variables are set.

## Build and Test
    mkdir build && cd build
    cmake ..
    make
    ./tests/RunAllTests


## Info

Traces are generated inside the build folder.

Add these lines to c_cpp_properties include path in VSCode to remove the squiggles.

    "actual-verilator-location/include",
    "${workspaceFolder}/build/vinclude"
    
