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
    with pkg_resources.open_text(resources, "module.sv") as file:
        apply_template(file, args.module + '.sv', base_project, template_filter)
    # with pkg_resources.open_text(resources, "module.h") as file:
    #    apply_template(file, args.module + '.h', base_project, template_filter)
    # with pkg_resources.open_text(resources, "module.cpp") as file:
    #    apply_template(file, args.module + '.cpp', base_project, template_filter)
    with pkg_resources.open_text(resources, "test_module.cpp") as file:
       apply_template(file, 'test_' + args.module + '.cpp', base_project, template_filter)
    