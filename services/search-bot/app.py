from flask import Flask

app = Flask(__name__)

@app.route("/search", methods=["POST"])
def search():
    """
    Search by ASIN or reference image
    """
    return {
        "asin": "ASIN123",
        "preview": "360.jpg",
        "download": "s3://shazam-assets/ASIN123/"
    }
