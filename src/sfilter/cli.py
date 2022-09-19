import click

from src.sfilter.app import run_all


@click.command()
@click.argument('path')
@click.option(
    '--output-path',
    '-0',
    required=False,
    type=str,
    default='.',
    show_default=True,
    help='Output path for generated files',
)
def main(path, output_path):
    """
    sfilter is a tool that refactors and runs static code analyses.
    sfilter goal is to improve code maintainability
    and prevent its degradation.
    """
    run_all(path, output_path)


if __name__ == '__main__':
    main()
