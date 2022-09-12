from src.sfilter.file_handling.file_finder import find_file_relative
from src.sfilter.quality_handler import QualityHandler
from src.sfilter.tools.black import run_black
from src.sfilter.tools.blue import run_blue
from src.sfilter.tools.flake8 import run_flake8
from src.sfilter.tools.isort import run_isort
from src.sfilter.tools.radon import run_radon

VERSION_ONE_PLUS = False


def clean_before_test() -> None:
    """Clean up analysis logs before tests"""
    find_file_relative('flake8.txt').delete()
    find_file_relative('radon.json').delete()


def run_all(path):
    """Run all sfilter steps against given path

    :param path:
    """
    clean_before_test()
    if VERSION_ONE_PLUS:
        run_black(path)
    run_blue(path)
    run_isort(path)
    run_flake8(path)
    run_radon(path)
    QualityHandler(path).compare_metrics()
