from pathlib import Path

with open(Path(__file__).parent.parent / "version.txt") as f:
    __version__ = f.read().strip()
