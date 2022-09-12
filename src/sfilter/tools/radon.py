"""
Call radon mi() command
"""

import radon.cli as cli


def run_radon(dir_path):
    cli.mi(paths=[dir_path], json=True, output_file='radon.json')
