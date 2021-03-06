""" Command Line Interface """
import argparse
import sys

from . import eda
from . import create
from . import sim

def my_test(args):
    return

# Main program interface
def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(prog="abies", description="Abies Audio Processing Framework")

    # Choose from main commands "new, build, test, etc."
    sp_command = parser.add_subparsers(metavar="command",dest="command")

    # Generate new abies project
    sp_create = sp_command.add_parser(
        'create',
        help="Generates a new Abies project or module."
    )
    create_group = sp_create.add_mutually_exclusive_group(required=True)
    create_group.add_argument(
        '--project',
        action='store',
        help="Create a new project."
    )
    create_group.add_argument(
        '--module',
        action='store',
        help="Create a new framework module."
    )
    create_group.add_argument(
        '--library',
        action='store',
        help="Create a new library module."
    )
 
    sp_create.set_defaults(func=create.create)

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

    sp_sim = sp_command.add_parser(
        'sim',
        help="Run the simulations."
    )
    sp_sim.add_argument(
        '--cmake',
        action='store_true',
        help="Run 'cmake ..' before running 'make'.",
        default=False,
        required=False
    )
    sp_sim.set_defaults(func=sim.sim)

    args = parser.parse_args()
    # try:
    args.func(args)
    # except:
    # parser.print_help()

# Main.
if __name__ == '__main__':
    sys.exit(main())
