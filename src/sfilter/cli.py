import click

from src.sfilter.app import run_all


@click.command()
@click.argument('path')
def main(path):
    run_all(path)


if __name__ == '__main__':
    main()
