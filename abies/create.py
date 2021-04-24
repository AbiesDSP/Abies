""" Command Line Interface """
import os
import importlib.resources as pkg_resources
from posix import WIFSTOPPED
from string import Template
import shutil
from . import resources

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

    if(args.module != None):
        create_module(args, template_filter)

def create_module(args, template_filter):
    # only create a module if nothing exists already.
    framework_dir = os.path.join(os.getcwd(), 'framework/')
    tests_dir = os.path.join(os.getcwd(), 'tests/')

    if os.path.exists(os.path.join(framework_dir, args.module)):
        print("Module: '" + args.module + "' already exists!")
        return

    # Generate source files.
    with pkg_resources.open_text(resources, "module.sv") as file:
        apply_template(file, args.module + '.sv', framework_dir, template_filter)

    with pkg_resources.open_text(resources, "test_module.cpp") as file:
       apply_template(file, 'test_' + args.module + '.cpp', tests_dir, template_filter)
    