from pathlib import Path
from typing import Optional


class Arguments:
    def __init__(self, dir_path: Path, file_name: Optional[str] = None):
        self.dir_path = dir_path
        self.file_name = file_name


def parse_arguments(**kwargs: str) -> Arguments:
    """Parse arguments that were given to sfilter

    :param kwargs:
    :return:
    """
    path = Path(kwargs['path'])

    if path.is_dir():
        dir_path = path
        file_name = None
    else:
        dir_path = path.parent
        file_name = path.name

    return Arguments(dir_path=dir_path, file_name=file_name)
