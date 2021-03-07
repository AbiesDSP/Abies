""" Command Line Interface """
import os
import importlib.resources as pkg_resources
from posix import WIFSTOPPED
from string import Template
import shutil
from . import resources
# from . import framework
# from . import util

def apply_template(src, dst, base_project, template_filter):
    the_template = Template(src.read())
    result = the_template.safe_substitute(template_filter)
    with open(os.path.join(base_project, dst), 'w') as module_cmake:
            module_cmake.write(result)

def create(args):
    if args.module != None:
        class_filt = ''.join(x.capitalize() or '_' for x in args.module.split('_'))
    else:
        class_filt = "module_name"

    template_filter = {
        'project_name' : args.project,
        'module_name' : args.module,
        'module_class' : class_filt
    }
    if args.project != None:
        print('create project')
        # create_project(args, template_filter)
    elif(args.module != None):
        create_module(args, template_filter)
    elif(args.library != None):
        print('create library')

def create_new_dir(new_path):
    # Create new directory, or reused existing directory.
    if os.path.exists(new_path):
        if os.path.isdir(new_path):
            new_work_dir = os.path.join(os.getcwd(), new_path)
        else:
            raise Exception("Error: '" + new_path + "' exists and is not a directory.")
    else:
        if os.path.basename(os.getcwd()) == new_path:
            new_work_dir = os.getcwd()
        else:
            new_work_dir = os.path.join(os.getcwd(), new_path)
            os.makedirs(new_work_dir, exist_ok=True)

    return new_work_dir

# Creates a new project in a local directory. Copies the framework, and creates
def create_project(args, template_filter):
    return
    # base_project = create_new_dir(args.project)
    # # Generate config file from template
    # if os.path.exists(os.path.join(base_project, 'config.yml')) == False:
    #     with pkg_resources.open_text(resources, "config.yml") as file:
    #         apply_template(file, 'config.yml', base_project, template_filter)

    # if os.path.exists(os.path.join(base_project, 'run_all_tests.cpp')) == False:
    #     with pkg_resources.open_text(resources, "run_all_tests.cpp") as file:
    #         apply_template(file, 'run_all_tests.cpp', base_project, template_filter)

    # # CMake project file for testing stuff.
    # if os.path.exists(os.path.join(base_project, 'CMakeLists.txt')) == False:
    #     # Generate CMakeLists.txt file for module
    #     with pkg_resources.open_text(resources, "cmake_project.txt") as file:
    #         apply_template(file, 'CMakeLists.txt', base_project, template_filter)

    # # Copy framework files to build directory. Always overwrites.
    # os.makedirs(os.path.join(base_project, "framework"), exist_ok=True)
    # banlist =  ['__pycache__', '__init__.py']
    # base_fw = os.path.join(base_project, 'framework')

    # # Copy all framework files to a local folder
    # for content in pkg_resources.contents(framework):
    #     with pkg_resources.path(framework, content) as x:
    #         # Don't copy python package files
    #         if os.path.basename(x) not in banlist:
    #             # Iterate through dirs to copy everything. Only 1 level deep.
    #             if os.path.isdir(x):
    #                 os.makedirs(os.path.join(base_fw, os.path.basename(x)), exist_ok=True)
    #                 for file in os.listdir(x):
    #                     shutil.copy(os.path.join(x, file), os.path.join(base_fw, os.path.basename(x), file))
    #             else:
    #                 shutil.copy(x, os.path.join(base_fw, os.path.basename(x)))
    
    # # Copy util files to build directory. Always overwrites.
    # os.makedirs(os.path.join(base_project, "util"), exist_ok=True)
    # base_util = os.path.join(base_project, 'util')

    # # Copy all util files to a local folder
    # for content in pkg_resources.contents(util):
    #     with pkg_resources.path(util, content) as x:
    #         # Don't copy python package files
    #         if os.path.basename(x) not in banlist:
    #             # Iterate through dirs to copy everything. Only 1 level deep.
    #             if os.path.isdir(x):
    #                 os.makedirs(os.path.join(base_util, os.path.basename(x)), exist_ok=True)
    #                 for file in os.listdir(x):
    #                     shutil.copy(os.path.join(x, file), os.path.join(base_util, os.path.basename(x), file))
    #             else:
    #                 shutil.copy(x, os.path.join(base_util, os.path.basename(x)))


def create_module(args, template_filter):

    # only create a module if nothing exists already.
    base_project = os.path.join(os.getcwd(), 'framework/', args.module)
    if os.path.exists(base_project):
        print("Module: '" + args.module + "' already exists!")
        return
    # Create new directory, or reused existing directory.
    base_project = create_new_dir(base_project)
    
    # Generate CMakeLists.txt file for module
    with pkg_resources.open_text(resources, "cmake_module.txt") as file:
       apply_template(file, 'CMakeLists.txt', base_project, template_filter)
    # Generate source files.
    with pkg_resources.open_text(resources, "module.v") as file:
        apply_template(file, args.module + '.v', base_project, template_filter)
    with pkg_resources.open_text(resources, "module.h") as file:
       apply_template(file, args.module + '.h', base_project, template_filter)
    with pkg_resources.open_text(resources, "module.cpp") as file:
       apply_template(file, args.module + '.cpp', base_project, template_filter)
    with pkg_resources.open_text(resources, "test_module.cpp") as file:
       apply_template(file, 'test_' + args.module + '.cpp', base_project, template_filter)
    