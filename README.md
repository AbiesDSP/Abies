# Abies
Open Source, Real Time, Digital Audio Effects Framkework

## Dependencies
- CMake
- Verilator
- CppUTest (Test framework)
- GTKWave (Viewing waveforms)
- Vivado (For synthesis/implementation)
- Edalize

    Make sure these are installed and their env variables are set.

    On Ubuntu/wsl, run "sudo apt install libtinfo5" if vivado crashes

## Build and Test
<!-- Install symbolic link to Abies

    $ cd abies
    $ python -m pip install -e . -->

Run Tests

Include the "--cmake" flag to configure cmake 

    $ python -m abies sim

## Contribute
Create a new framework module from a template using this command

    $ python -m abies create --module module_name

Update the CMakeLists.txt files to add the new library and test groups.
<!-- Create a new abies project (Not fully working)

    $ cd some_directory
    $ python -m abies new --project foo

Create a new module (Not fully working)

    $ cd project_dir
    $ python -m abies new --module bar -->


## Info

Traces are generated inside the build folder under 'build/traces'
Use GTKWave to view them.

Add these lines to c_cpp_properties include path in VSCode to remove the squiggles.

    "actual-verilator-location/include",
    "${workspaceFolder}/build/verilated"
    
