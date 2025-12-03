# app/__init__.py
from flask import Flask, jsonify
from .config import Config
from .extensions import db, cors
from .errors import register_error_handlers

def register_blueprints(app: Flask):

    # -------------------------
    # Import all blueprints
    # -------------------------
    from .blueprints.auth import bp as bp_auth
    from .blueprints.onboarding import bp as bp_onboard
    from .blueprints.transactions import bp as bp_txns
    from .blueprints.categories import bp as categories_bp
    from .blueprints.bills import bp as bills_bp
    from .blueprints.goals import bp as goals_bp
    from .blueprints.achievements import bp as achievements_bp
    from .blueprints.insights import bp as insights_bp
    from .blueprints.dashboard import bp as dashboard_bp

    # ⭐ ML BLUEPRINT IMPORT (NEW)
    from .blueprints.ml import ml_bp

    # -------------------------
    # Register all blueprints
    # -------------------------
    app.register_blueprint(bp_auth, url_prefix="/api/v1")
    app.register_blueprint(categories_bp, url_prefix="/api/v1")
    app.register_blueprint(bp_onboard, url_prefix="/api/v1")
    app.register_blueprint(bp_txns, url_prefix="/api/v1")
    app.register_blueprint(bills_bp, url_prefix="/api/v1")
    app.register_blueprint(goals_bp, url_prefix="/api/v1")
    app.register_blueprint(achievements_bp, url_prefix="/api/v1")
    app.register_blueprint(insights_bp, url_prefix="/api/v1")
    app.register_blueprint(dashboard_bp, url_prefix="/api/v1")

    # ⭐ REGISTER ML BLUEPRINT (NEW)
    app.register_blueprint(ml_bp, url_prefix="/api/v1")


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # -------------------------
    # Initialize database
    # -------------------------
    db.init_app(app)

    # -------------------------
    # CORS (for Vite)
    # -------------------------
    cors.init_app(
        app,
        resources={
            r"/api/*": {
                "origins": [
                    "http://127.0.0.1:5173",
                    "http://localhost:5173"
                ],
                "methods": ["GET","POST","PUT","PATCH","DELETE","OPTIONS"],
                "allow_headers": ["Content-Type","Authorization"],
                "supports_credentials": True,
            }
        }
    )

    # Register all routes
    register_blueprints(app)

    # Register error handlers
    register_error_handlers(app)

    # Health check
    @app.get("/")
    def health():
        return jsonify({"ok": True, "service": "smartspend-backend"})

    return app
