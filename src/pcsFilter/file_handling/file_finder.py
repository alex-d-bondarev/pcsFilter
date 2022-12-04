from pathlib import Path
from typing import Optional

from src.pcsFilter.file_handling.abstract_file_handler import AFileHandler
from src.pcsFilter.file_handling.existing_file import ExistingFile
from src.pcsFilter.file_handling.non_existing_file import NonExistingFile


def find_file(name: str, path: Optional[str] = None) -> AFileHandler:
    """Find file by given name and return it in the form of AFileHandler

    :param name:
    :param path:
    :return:
    """
    try:
        if path:
            if path.endswith('.py'):
                return ExistingFile(Path(path))
            else:
                return ExistingFile(Path(path + name))
        else:
            return ExistingFile(
                next(Path(__file__).parent.parent.parent.parent.glob(name))
            )
    except StopIteration:
        return NonExistingFile(name)


def file_from_path(path: Path) -> AFileHandler:
    """Find file by given path and return it in the form of AFileHandler

    :param path:
    :return:
    """
    try:
        return ExistingFile(Path(path))
    except (StopIteration, FileNotFoundError):
        return NonExistingFile(str(path))


def file_from_same_dir(name: str) -> AFileHandler:
    """
    Find file in the current directory
    and return it in the form of AFileHandler
    """
    relative_file_path = Path('.') / name
    return file_from_path(relative_file_path)
