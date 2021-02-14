""" Command Line Interface """
import argparse
import sys

from . import eda

def my_test(args):
    return

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(prog="abies", description="Abies Audio Processing Framework")

    sp_command = parser.add_subparsers(metavar="command",dest="command")

    # Choose from main commands "build, test, etc."
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
    try:
        args.func(args)
    except:
        parser.print_help()

# Main.
if __name__ == '__main__':
    sys.exit(main())
