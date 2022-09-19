import re
from pathlib import Path

from src.sfilter.file_handling.file_finder import file_from_path
from src.sfilter.setup_handler import SetUpHandler


class QualityHandler:
    """Handle quality metrics"""

    def __init__(self, path: str, output_path: Path):
        self.path = path
        self.output_path = output_path

    def compare_metrics(self):
        """Compare initial metrics with new metrics"""
        self._count_new_flake8_flags()
        self._calculate_new_cc_stats()
        self._load_previous_metrics()
        self._compare_flake8()
        self._compare_mi()
        self._save_result()

    def _count_new_flake8_flags(self):
        last_line_does_not_count = 1
        flake8_content = self._load_content(file_name='flake8.txt')
        self.new_flake8 = (
            len(flake8_content.split('\n')) - last_line_does_not_count
        )

    def _calculate_new_cc_stats(self):
        radon_content = self._load_content(file_name='radon.txt')
        self.new_cc = 0

        for line in radon_content.split('\n'):
            if 'Average complexity' in line:
                self.new_cc = re.search(r'\((.*)\)', line).group(1)

    def _load_previous_metrics(self):
        self.setup = SetUpHandler()
        self.init_flake8 = self._load_init_value('flake8')
        self.init_mi = self._load_init_value('mi')

    def _load_init_value(self, key: str):
        value = self.setup.get(key)
        if value == '-1':
            return None
        else:
            return value

    def _load_content(self, file_name: str):
        wrapped_path = self.output_path / file_name
        file_content = file_from_path(wrapped_path).get_content()
        return file_content

    def _compare_flake8(self):
        if self.init_flake8 is not None:
            assert int(self.init_flake8) >= self.new_flake8, (
                f'Flake8 score was {self.init_flake8} '
                f'but became {self.new_flake8}. '
                'You have introduced new pip8 errors. '
                'Please check flake8.txt for details. '
                'Please fix all new and maybe some old errors'
            )

    def _compare_mi(self):
        if self.init_mi is not None:
            assert float(self.init_mi) <= self.new_cc, (
                f'Radon maintainability index was {self.init_mi} '
                f'but became {self.new_cc}. '
                'You have made code less maintainable. '
                'Please check radon.txt for details. '
                'Please improve maintainability back. '
                'Appreciate if you make it even better. '
            )

    def _save_result(self):
        self.setup.set('flake8', str(self.new_flake8))
        self.setup.set('cc', str(self.new_cc))
        self.setup.save()
