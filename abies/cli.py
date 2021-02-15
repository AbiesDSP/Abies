""" Command Line Interface """
import argparse
from genericpath import exists
import os, sys
from os import path
import importlib.resources as pkg_resources
from string import Template
import shutil
import pkgutil
from . import eda
from . import resources
from . import framework

def my_test(args):
    return

# Creates a new project in a local directory. Copies the framework, and creates
def new_project(args):
    # Create new directory, or reused existing directory.
    if os.path.exists(args.project_name):
        if os.path.isdir(args.project_name):
            base_project = os.path.join(os.getcwd(), args.project_name)
        else:
            print("Error:" + args.project_name + "exists and is not a directory.")
            return 0
    else:
        if os.path.basename(os.getcwd()) == args.project_name:
            base_project = os.getcwd()
        else:
            base_project = os.path.join(os.getcwd(), args.project_name)
            os.makedirs(base_project, exist_ok=True)
    
    # Generate config file from template
    if os.path.exists(os.path.join(base_project, 'config.yml')) == False:
        with pkg_resources.open_text(resources, "config.yml") as config_file:
            d = {'project_name' : args.project_name}
            config_template = Template(config_file.read())
            # replace project name 
            result = config_template.substitute(d)
            with open(os.path.join(base_project, "config.yml"), 'w') as user_config:
                user_config.write(result)

    # Copy framework files to build directory. Always overwrites.
    os.makedirs(os.path.join(base_project, "framework"), exist_ok=True)
    banlist =  ['__pycache__', '__init__.py']
    base_fw = os.path.join(base_project, 'framework')

    # Copy all framework files to a local folder
    for content in pkg_resources.contents(framework):
        with pkg_resources.path(framework, content) as x:
            # Don't copy python package files
            if os.path.basename(x) not in banlist:
                # Iterate through dirs to copy everything. Only 1 level deep.
                if os.path.isdir(x):
                    os.makedirs(os.path.join(base_fw, os.path.basename(x)), exist_ok=True)
                    for file in os.listdir(x):
                        shutil.copy(os.path.join(x, file), os.path.join(base_fw, os.path.basename(x), file))
                else:
                    shutil.copy(x, os.path.join(base_fw, os.path.basename(x)))

# Main program interface
def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(prog="abies", description="Abies Audio Processing Framework")

    # Choose from main commands "new, build, test, etc."
    sp_command = parser.add_subparsers(metavar="command",dest="command")

    # Generate new abies project
    sp_new = sp_command.add_parser(
        'new',
        help="Generates a new Abies project"
    )
    sp_new.add_argument(
        'project_name',
        action='store',
        help="Abies project name"
    )
    sp_new.set_defaults(func=new_project)

    # Build a project for a physical device
    sp_build = sp_command.add_parser(
        'build',
        help="Generates build scripts."
    )
    # Specify config file
    sp_build.add_argument(
        '--config',
        action='store',
        help="Specify project config.yml file.",
        default=None,
        required=False,
        metavar='config_file'
    )
    sp_build.add_argument(
        '--scripts_only',
        action='store_true',
        help="Only generate build scripts.",
        default=None,
        required=False
    )
    sp_build.set_defaults(func=eda.build)

    sp_test = sp_command.add_parser(
        'test',
        help="Run tests."
    )
    sp_test.set_defaults(func=my_test)

    args = parser.parse_args()
    # try:
    args.func(args)
    # except:
    # parser.print_help()

# Main.
if __name__ == '__main__':
    sys.exit(main())
