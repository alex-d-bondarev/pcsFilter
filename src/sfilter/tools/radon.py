"""
Call radon mi() command
"""

import radon.cli as cli


def run_radon(dir_path):
    cli.cc(
        paths=[dir_path],
        no_assert=True,
        total_average=True,
        output_file='radon.txt',
    )
