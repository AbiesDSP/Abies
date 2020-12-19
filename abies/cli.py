""" Command Line Interface """
import argparse
import sys

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(prog="abies", description="Abies Audio Processing Framework")
    parser.add_argument(
        '--test',
        action='store_true',
        dest='test',
        default=None,
        help="Run tests on abies"
    )

    args = parser.parse_args()


if __name__ == '__main__':
    sys.exit(main())
