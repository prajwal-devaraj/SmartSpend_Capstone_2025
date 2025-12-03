import joblib
import os

BASE_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 
    "ml_models"
)

def load(name):
    return joblib.load(os.path.join(BASE_PATH, name))

models = {
    # ⭐ Tier 1
    "tier1_spend": load("tier1_spend_model (6).pkl"),
    "tier1_features": load("tier1_feature_cols (5).pkl"),

    # ⭐ Tier 2
    "tier2_burn": load("tier2_burn_model (4).pkl"),
    "tier2_runway": load("tier2_runway_model (4).pkl"),
    "tier2_features": load("tier2_feature_cols (4).pkl"),

    # ⭐ Tier 3
    "tier3_late": load("tier3_late_night_model (1).pkl"),
    "tier3_over": load("tier3_overspend_model (1).pkl"),
    "tier3_guilt": load("tier3_guilt_model (1).pkl"),
    "tier3_features": load("tier3_feature_cols (1).pkl"),
}
