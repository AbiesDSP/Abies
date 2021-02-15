""" Command Line Interface """
import argparse
from genericpath import exists
import sys
from . import eda
from . import new

def my_test(args):
    return

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
    new_group = sp_new.add_mutually_exclusive_group(required=True)
    new_group.add_argument(
        '--project',
        action='store',
        help="Project name"
    )
    new_group.add_argument(
        '--module',
        action='store',
        help="Module name."
    )
 
    sp_new.set_defaults(func=new.new)

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
