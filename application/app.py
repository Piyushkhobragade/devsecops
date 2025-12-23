from flask import Flask, request, jsonify, render_template_string
import os
import yaml
import subprocess

app = Flask(__name__)

# INTENTIONAL VULNERABILITY 1: Hardcoded secret
API_KEY = "sk-1234567890abcdef"  # This will be caught by TruffleHog
# trigger trufflehog scan
# INTENTIONAL VULNERABILITY 2: SQL Injection risk
@app.route('/user/<username>')
def get_user(username):
    # Vulnerable to path traversal
    return f"User data: {username}"

# INTENTIONAL VULNERABILITY 3: SSTI (Server-Side Template Injection)
@app.route('/render')
def render():
    template = request.args.get('template', 'Hello World')
    return render_template_string(template)

# INTENTIONAL VULNERABILITY 4: Command Injection
@app.route('/ping')
def ping():
    host = request.args.get('host', 'localhost')
    result = subprocess.run(f'ping -c 1 {host}', shell=True, capture_output=True)
    return result.stdout.decode()

# INTENTIONAL VULNERABILITY 5: Unsafe YAML loading
@app.route('/config', methods=['POST'])
def load_config():
    config_data = request.data
    config = yaml.load(config_data, Loader=yaml.Loader)  # Unsafe!
    return jsonify(config)

# Healthy endpoint for monitoring
@app.route('/health')
def health():
    return jsonify({"status": "healthy", "version": "1.0.0"})

# Secure endpoint (demonstrates good practice)
@app.route('/api/v1/status')
def status():
    return jsonify({
        "status": "running",
        "environment": os.environ.get("ENVIRONMENT", "production")
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
