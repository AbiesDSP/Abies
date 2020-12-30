# Abies
Open Source, Real Time, Digital Audio Effects Framkework

## Dependencies
- CMake
- Verilator
- CppUTest (Test framework)
- GTKWave (Viewing waveforms)
- Vivado

    Make sure these are installed and their env variables are set.

    On Ubuntu/wsl, run "sudo apt install libtinfo5" if vivado crashes

## Build and Test
    mkdir build && cd build
    cmake ..
    make
    ./tests/run_all_tests

    python -m abies


## Info

Traces are generated inside the build folder.

Add these lines to c_cpp_properties include path in VSCode to remove the squiggles.

    "actual-verilator-location/include",
    "${workspaceFolder}/build/vinclude"
    
