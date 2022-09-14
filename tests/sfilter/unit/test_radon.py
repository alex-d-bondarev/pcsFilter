from pathlib import Path

import pytest  # noqa

from src.sfilter.file_handling.file_finder import find_file
from src.sfilter.tools.radon import run_radon
from tests.sfilter.unit.fixtures import create_temp_file  # noqa


@pytest.mark.unit
def test_radon():
    """Test that radon is launched"""
    expected_content = 'Average complexity'
    run_radon(str(Path(__file__).resolve()))

    file_handler = find_file("radon.txt")
    actual_content = file_handler.get_content()
    file_handler.delete()

    assert expected_content in actual_content
