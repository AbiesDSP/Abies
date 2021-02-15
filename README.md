# Abies
Open Source, Real Time, Digital Audio Effects Framkework

## Dependencies
- CMake
- Verilator
- CppUTest (Test framework)
- GTKWave (Viewing waveforms)
- Vivado
- Edalize

    Make sure these are installed and their env variables are set.

    On Ubuntu/wsl, run "sudo apt install libtinfo5" if vivado crashes

## Build and Test
    # Install symbolic link
    $ cd abies
    $ python -m pip install -e .
    
Create a new abies project

    $ cd some_directory
    $ python -m abies new --project foo

Create a new module

    $ cd project_dir
    $ python -m abies new --module bar


## Info

Traces are generated inside the build folder.

Add these lines to c_cpp_properties include path in VSCode to remove the squiggles.

    "actual-verilator-location/include",
    "${workspaceFolder}/build/vinclude"
    
