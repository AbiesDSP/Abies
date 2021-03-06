import os, sys
import subprocess

# Run cmake commands to configure and build the project.
def sim(args):
    original_wd = os.getcwd()
    os.makedirs('build', exist_ok=True)
    os.chdir(os.path.join(original_wd, 'build'))

    # If --cmake flag, we need to run 'cmake ..' first
    if args.cmake:
        cmake_cmd = ['cmake', '..']
        try:
            subprocess.run(cmake_cmd, check=True)
        except:
            return

    # Run make.
    cmake_cmd = ['make']
    try:
        subprocess.run(cmake_cmd, check=True)
    except subprocess.CalledProcessError as e:
        print("make failed with error %d" % e.returncode)
        return

    subprocess.run(['./tests/run_all_tests'], check=True)
    # Go back to original working directory.
    os.chdir(original_wd)
