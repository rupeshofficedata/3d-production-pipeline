import zipfile
import sys

# Define contract between artist and system
REQUIRED_FILES = [
    "model.glb",
    "model.obj"
]

def validate(zip_path):
    """
    Validates ZIP file before QA.
    """

    # Open ZIP safely
    with zipfile.ZipFile(zip_path) as z:
        files = z.namelist()

        # Check required files
        for required in REQUIRED_FILES:
            if required not in files:
                raise Exception(
                    f"Missing required file: {required}"
                )

if __name__ == "__main__":
    validate(sys.argv[1])
