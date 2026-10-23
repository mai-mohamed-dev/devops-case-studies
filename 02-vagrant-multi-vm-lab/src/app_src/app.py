from flask import Flask, jsonify
import psycopg2
 
app = Flask(__name__)
 
# LAB ONLY: hard-coded credentials. Use environment variables or a secret store in real projects.
DB = dict(host="192.168.56.12", dbname="appdb", user="appuser",
          password="apppass", connect_timeout=3)
 
@app.route("/health")
def health():
    return jsonify(status="ok")
 
@app.route("/db-check")
def db_check():
    try:
        conn = psycopg2.connect(**DB)
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        conn.close()
        return jsonify(db="ok", version=version)
    except Exception as e:
        return jsonify(db="error", detail=str(e)), 500