
from flask import Flask, jsonify
from app.routes.user_routes import user_blueprint
from app.routes.product_routes import product_blueprint

def create_app():
    app = Flask(__name__)

    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health():
        return jsonify({"status": "healthy"}), 200

    @app.route('/', methods=['GET'])
    def root():
        return jsonify({"message": "Microservices API", "status": "running"}), 200

    # Register blueprints
    app.register_blueprint(user_blueprint)
    app.register_blueprint(product_blueprint)

    return app
