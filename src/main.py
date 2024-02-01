"""When run as the main module, this script takes as input a verilog design 
module and executes a synthesis flow using Yosys. 

Usage 
-----
    python3 main.py DESIGN_PATH TOP_MODULE_ID 
        DESIGN_PATH             The path to your .sv
        TOP_MODULE_ID           The name of the module to synthesize. 
"""
from pathlib import Path
import subprocess 

import typer

PROJECT_DIRECTORY: Path = Path(__file__).parent.parent.absolute()
DESIGN_DIRECTORY: Path = PROJECT_DIRECTORY / "design" 
JSON_DIRECTORY: Path = PROJECT_DIRECTORY / "json" 
MEDIA_DIRECTORY: Path = PROJECT_DIRECTORY / "media" 
SYNTHESIS_DIRECTORY: Path = PROJECT_DIRECTORY / "media" 
LOG_DIRECTORY: Path = PROJECT_DIRECTORY / "logs" 
TEMPLATE_PATH: Path = PROJECT_DIRECTORY / "src/synthesis_template.ys"


def make_synthesis_script(output_directory: Path, design_path: Path, top_id: str) -> Path: 
    output_path: Path = output_directory / "synthesize.ys" 
    design_name: str = design_path.stem

    substitutions: dict = {
        "DESIGN_PATH": str(design_path), 
        "TOP_MODULE": top_id, 
        "JSON_PATH": str(output_directory / f"{design_name}.json"), 
        }

    with open(TEMPLATE_PATH, "r") as handle: 
        content = handle.read()

        for old_value, new_value in substitutions.items(): 
            content = content.replace(old_value, new_value)

    with open(output_path, "w") as handle: 
        handle.write(content)

def main(design_path: Path, top_id: str): 
    output_directory = LOG_DIRECTORY / "new" 
    output_directory.mkdir(exist_ok=True)
    output_path: Path = output_directory / "synthesize.ys" 
    design_name: str = design_path.stem
    json_path: Path = str(output_directory / f"{design_name}.json")

    make_synthesis_script(output_directory, Path(design_path), top_id)
    print("Made synthesis script")

    subprocess.call(["yosys", f"{str(output_path)}"])
    print("Ran yosys")

    subprocess.call(["netlistsvg", f"{json_path}", "-o", f"{str(output_directory / 'implementation.svg')}"])
    print("Generated svg")

if __name__=="__main__": 
    typer.run(main)
