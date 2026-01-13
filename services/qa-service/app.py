from flask import Flask, request

app = Flask(__name__)

@app.route("/qa/decision", methods=["POST"])
def qa_decision():
    """
    QA decision endpoint.
    """

    decision = request.json["decision"]

    if decision == "reject":
        return {"status": "reassigned"}

    return {"status": "approved"}
