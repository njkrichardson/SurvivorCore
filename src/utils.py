from pathlib import Path 
from typing import Iterable

SOURCE_DIRECTORY: Path = Path(__file__).parent
PROJECT_DIRECTORY: Path = SOURCE_DIRECTORY.parent 
VECTORS_DIRECTORY: Path = PROJECT_DIRECTORY / "vectors" 
TESTS_DIRECTORY: Path = PROJECT_DIRECTORY / "tests"
TEST_BIN_DIRECTORY: Path = TESTS_DIRECTORY / "bin"


AUTO_BUILT_DIRECTORIES: Iterable[Path] = (
        VECTORS_DIRECTORY, 
        TESTS_DIRECTORY, 
        TEST_BIN_DIRECTORY, 
        )

for directory in AUTO_BUILT_DIRECTORIES: 
    directory.mkdir(exist_ok=True)
