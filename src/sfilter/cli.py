import click

from src.sfilter.app import run_all


@click.command()
@click.argument('path')
@click.option(
    '--output-path',
    '-0',
    required=False,
    type=str,
    default='.sfilter',
    show_default=True,
    help='Output path for generated files',
)
@click.option('--strict', '-s', is_flag=True, help='Turn on strict mode')
def main(path, output_path, strict):
    """
    sfilter is a tool that refactors and runs static code analyses.
    sfilter goal is to improve code maintainability
    and prevent its degradation.
    """
    run_all(path, output_path, strict)


if __name__ == '__main__':
    main()
