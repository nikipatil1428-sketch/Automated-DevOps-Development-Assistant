from flask import Flask, jsonify
import os
import socket
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "DevOps Assistant Running Successfully!",
        "host": socket.gethostname(),
        "version": os.getenv("VERSION", "1.0.0"),
        "timestamp": str(datetime.datetime.now()),
        "status": "active"
    })

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": str(datetime.datetime.now())
    }), 200

@app.route('/info')
def info():
    return jsonify({
        "platform": "Docker",
        "automation": "CI/CD Pipeline Ready",
        "monitoring": "Prometheus + Grafana",
        "features": [
            "Auto-build",
            "Auto-test", 
            "Auto-deploy",
            "Health checks",
            "Load balancing"
        ]
    })

@app.route('/metrics')
def metrics():
    return jsonify({
        "cpu_usage": "15%",
        "memory_usage": "128MB",
        "requests_per_second": 45,
        "uptime_seconds": 3600
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)