from flask import Flask, request, jsonify
import time

# Create a Flask web server
app = Flask(__name__)

@app.route("/assign", methods=["POST"])
def assign_task():
    """
    Assigns a model to an artist.

    This endpoint is called when:
    - New model arrives
    - QA rejects a model
    """

    # Read data sent by client
    artist_id = request.json["artist_id"]
    asin = request.json["asin"]

    # Return structured response
    return jsonify({
        "artist_id": artist_id,
        "asin": asin,
        "stage": "cleanup",      # Always start here
        "assigned_at": time.time()
    })
