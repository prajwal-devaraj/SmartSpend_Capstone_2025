from flask import Blueprint, request, jsonify
from app.services.ml_loader import models
import numpy as np

ml_bp = Blueprint("ml", __name__)

@ml_bp.route("/ml/predict", methods=["POST"])
def ml_predict():
    try:
        data = request.get_json()

        if "features" not in data:
            return jsonify({"error": "Missing 'features'"}), 400

        full_features = np.array(data["features"]).reshape(1, -1)

        # --------------------------
        # ⭐ TIER 1 needs only 5 features
        # --------------------------
        tier1_needed = len(models["tier1_features"])
        X_tier1 = full_features[:, :tier1_needed]

        # --------------------------
        # ⭐ TIER 2 & 3 use all features (11)
        # --------------------------
        X_full = full_features

        # ⭐ Tier 1 Prediction
        tier1_spend = float(models["tier1_spend"].predict(X_tier1)[0])

        # ⭐ Tier 2
        burn = float(models["tier2_burn"].predict(X_full)[0])
        runway = float(models["tier2_runway"].predict(X_full)[0])

        # ⭐ Tier 3
        late = float(models["tier3_late"].predict_proba(X_full)[0][1])
        over = float(models["tier3_over"].predict_proba(X_full)[0][1])
        guilt = float(models["tier3_guilt"].predict_proba(X_full)[0][1])

        return jsonify({
            "tier1": {
                "spend_prediction": tier1_spend
            },
            "tier2": {
                "burn_rate": burn,
                "runway_days": runway
            },
            "tier3": {
                "risk_late_night": late,
                "risk_overspend": over,
                "risk_guilt": guilt
            }
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500
