# Customer-Retention-Churn-Analytics
📊 Analyzing customer behavior, churn drivers, and revenue impact to improve retention strategies

📌 Overview

This project focuses on analyzing telecom customer churn using SQL, Power BI, and DAX to uncover key drivers of churn and provide actionable business insights.

👉 The goal is to help businesses reduce customer attrition and improve retention strategies.

🧠 Business Problem

Customer churn leads to significant revenue loss.
The company lacked visibility into:

Why customers churn
Which segments are at risk
What actions can reduce churn

🎯 Objective

Identify churn patterns
Segment high-risk customers
Analyze churn drivers
Provide actionable recommendations

🗂️ Dataset

The dataset includes:

Customer demographics
Service usage (Internet, Streaming, etc.)
Billing & revenue data
Customer churn status and reasons

⚙️ Data Preparation (Power Query)

Created Churn Status (1/0) column
Handled null values
Unpivoted service columns
Created a structured Services table

🧮 DAX Measures

Total Customers = DISTINCTCOUNT(prod_churn[Customer_ID])

Churned Customers = 
CALCULATE(
    COUNTROWS(prod_churn),
    prod_churn[Customer_Status] = "Churned"
)

Churn % = [Churned Customers]/[Total Customers]

Revenue Lost = 
CALCULATE(
    SUM(prod_churn[Total_Revenue]),
    prod_churn[Customer_Status] = "Churned"
)

ARPU = DIVIDE([Total Revenue], [Total Customers], 0)

📊 Dashboard Overview

<img width="1280" height="722" alt="Customer Retention   Churn Analytics" src="https://github.com/user-attachments/assets/866170ef-9981-4272-bb65-ead9871f5455" />

Key Features:
KPI cards (Customers, Churn %, Revenue Lost, ARPU)
Customer segmentation (Age, Tenure, Contract)
Churn drivers (Category, Reason)
Geographic analysis (State)
Interactive slicers

Tooltip:

<img width="544" height="312" alt="Customer Retention   Churn Analytics II" src="https://github.com/user-attachments/assets/6bc6c7f2-6b1f-423d-bfbe-025543235036" />


📈 Key Insights

🔴 Where is the problem?
Month-to-Month contracts show the highest churn
New customers (0–6 months) are high-risk
🟡 Why customers churn?
Competitor offers better pricing/devices
High pricing dissatisfaction
Poor service experience
🔵 Who is at risk?
Fiber users
High monthly charge customers
Low tenure customers

💡 Recommendations

Promote long-term contracts
Improve service quality (especially for Fiber users)
Provide targeted offers for new customers
Implement competitive pricing strategies

📉 Impact

Identified key churn drivers
Enabled data-driven retention strategies
Highlighted revenue loss areas

🛠️ Tools & Technologies

MySQL – Data analysis
Power BI – Dashboard & visualization
DAX – KPI calculations
Power Query – Data transformation


⭐ If you like this project

Give it a ⭐ on GitHub!
👉 Say "LinkedIn post"
I’ll write a viral recruiter-attracting post for this project 🔥
