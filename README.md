# SMARTSPEND — THE EMOTION-AWARE CASH-FLOW COACH 

---

## Project Overview

**SmartSpend** is an personal finance management system designed to help users not only track spending, but **understand emotional and behavioral triggers behind their financial decisions**.

Unlike traditional budgeting apps, SmartSpend combines **transaction analytics, emotional tagging, machine learning predictions, and runway estimation** to empower smarter financial habits.

---

## Goals & Objectives

- Track income and expenses with intelligent categorization  
- Classify spending using **NWG (Need–Want–Guilt)** and **Mood tags**  
- Predict **burn rate**, **runway**, and **future risk**  
- Provide **ML-driven insights and alerts**  
- Support financial planning through **goals and bills management**

---

## Major Features

### Authentication
- JWT-based Signup & Login
- Secure token handling
- Onboarding flow for new users

### Dashboard
- Real-time balance
- Average daily burn rate
- Runway (days left)
- Power-save projection
- Achievements and insights preview

### Transactions
- Add / Edit / Delete income & expenses
- NWG + Mood classification
- Filters by category, merchant, date, and time

### Bills & Recurring Payments
- Monthly cadence recognition
- Next-due date tracking
- Upcoming bill alerts

### Goals & Runway Tracking
- Custom savings goals
- Target days configuration
- Progress visualization

### Machine Learning Insights
- Emotional overspending detection
- Burn rate prediction
- Tier-1 / Tier-2 / Tier-3 risk forecasting
- Smart alerts and recommendations

---

## System Architecture

### Frontend
- React + TypeScript  
- Tailwind CSS  
- Recharts for data visualization  
- Axios for API integration  

### Backend
- Flask  
- Flask-SQLAlchemy  
- JWT-based Authentication  
- RESTful APIs  

### Database
- MySQL (Relational schema)  
- Core tables:  
  - User  
  - Transaction  
  - Goals  
  - Bills  
  - Insights  

### Machine Learning
- Scikit-learn  
- Logistic Regression  
- Linear Regression  
- Serialized models (`.pkl` files)  

---

## Testing & Validation

### Testing Approach
- Unit testing for backend APIs  
- Integration testing (Authentication → Dashboard → Transactions)  
- System testing using automated scripts  
- Manual user testing sessions  

### Testing Tools
- Python-based test scripts  
- cURL and Postman  
- Automated API validation  

### Validation
- Functional requirements verified against specifications  
- End-to-end user workflows tested  
- Stakeholder and user feedback incorporated  

---

## User & Stakeholder Feedback

- Surveys conducted before and after application development  
- Live feedback sessions conducted at:
  - Kent State University Library  
  - KSU Culinary Services
  - and more

### Participant Age Groups
- 18–40  
- 40–65  
- 65+  

### Feedback Collection Methods
- Digital surveys  
- Manual in-person interactions  

**Overall feedback was highly positive**, particularly for:
- Spending insights  
- Burn rate visibility  
- Runway prediction accuracy  

---

## Deployment

### Backend
- Hosted locally or on a university server during testing  
- Flask application served using Gunicorn  

### Frontend
- Deployed using GitHub Codespaces  

**Example Deployment URL:**
https://your-frontend-url.app.github.dev/

> Replace this with your active deployment link

---

## How to Run Locally

### Backend Setup
```
cd backend
pip install -r requirements.txt
python manage.py
```
## Frontend Setup
```
cd frontend
npm install
npm run dev
```

## Repository Structure
```
SmartSpend/
│
├── backend/
│   ├── app/
│   ├── blueprints/
│   ├── ml/
│   ├── models/
│   └── manage.py
│
├── frontend/
│   ├── src/
│   ├── pages/
│   ├── components/
│   └── vite.config.ts
│
└── README.md
```

## Results & Evaluation

- Successfully delivered all planned project features within scope and timeline  
- Machine learning models performed as expected for burn rate, runway, and insight prediction  
- Users demonstrated improved awareness of spending behavior and financial habits  
- The system met both **academic objectives** and **real-world usability goals**

---

## Future Work

- Development of a dedicated mobile application (Android / iOS)  
- Integration with bank APIs for real-time transaction synchronization  
- Adoption of advanced machine learning models such as LSTM and time-series forecasting  
- Introduction of personalized financial coaching and recommendation engines  
- Support for multi-currency transactions and international users  

---

## Appendices

- **GitHub Repository:**  
  https://github.com/prajwal-devaraj/SmartSpend_Capstone_2025.git  

- **Sample API Responses & Automated Test Scripts:**  

/backend/tests


- Additional system diagrams, sequence flows, and technical details are included in the full project report  

---

## References

- Flask Official Documentation  
- React & TypeScript Documentation  
- Scikit-learn Model Persistence Guide  
- JSON Web Token (JWT) – RFC 7519  
- Kent State University Course Materials  

---

## Conclusion

SmartSpend demonstrates how **modern web technologies**, **machine learning**, and **behavioral analytics** can be combined to create an intelligent personal finance platform.  
Unlike traditional budgeting tools that only track expenses, SmartSpend focuses on understanding the **underlying reasons behind spending behavior**, making it both **technically robust** and **socially impactful**.

