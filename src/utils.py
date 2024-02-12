from pathlib import Path 
from typing import Iterable

SOURCE_DIRECTORY: Path = Path(__file__).parent
PROJECT_DIRECTORY: Path = SOURCE_DIRECTORY.parent 
VECTORS_DIRECTORY: Path = PROJECT_DIRECTORY / "vectors" 

AUTO_BUILT_DIRECTORIES: Iterable[Path] = (
        VECTORS_DIRECTORY, 
        )

for directory in AUTO_BUILT_DIRECTORIES: 
    directory.mkdir(exist_ok=True)
