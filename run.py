from app.main import app

if __name__ == "__main__":
    print("Starting Flask application...")
    app.run(host='0.0.0.0', port=5000)
