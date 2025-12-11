import requests
import json

BASE = "http://localhost:5000/api/v1"

print("\n===== TEST: SIGNUP =====")
signup_payload = {
    "name": "Test User",
    "email": "sandeep.enaman@gmail.com",
    "password": "Mitchell2023@1"
}
r = requests.post(f"{BASE}/auth/signup", json=signup_payload)
print("Signup status:", r.status_code)
print("Signup response:", r.text)

print("\n===== TEST: LOGIN =====")
login_payload = {
    "email": "sandeep.enamandala@gmail.com",
    "password": "Mitchell2023@1"
}
r = requests.post(f"{BASE}/auth/login", json=login_payload)
print("Login status:", r.status_code)
print("Login response:", r.text)

if r.status_code != 200:
    print("❌ Login failed. Cannot continue tests.")
    exit()

tokens = r.json()
access = tokens["access_token"]
headers = {"Authorization": f"Bearer {access}"}

print("\n===== TEST: CREATE TRANSACTION =====")
txn_payload = {
    "amount_cents": 1234,
    "type": "expense",
    "category": "food",
    "mood": "happy",
    "note": "Testing transaction"
}
r = requests.post(f"{BASE}/transactions", json=txn_payload, headers=headers)
print("Transaction status:", r.status_code)
print("Transaction response:", r.text)

print("\n===== TEST: GET DASHBOARD =====")
r = requests.get(f"{BASE}/dashboard/kpis", headers=headers)
print("Dashboard status:", r.status_code)
print("Dashboard data:", r.text)

print("\n===== TEST: GET ALL TRANSACTIONS =====")
r = requests.get(f"{BASE}/transactions", headers=headers)
print("Transactions status:", r.status_code)
print("Transactions:", r.text)

print("\n===== ALL TESTS COMPLETED =====")
