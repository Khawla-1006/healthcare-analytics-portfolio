# 🧠 Methodology & AI Collaboration Report
**Project Phase:** Phase 3: Exploratory Data Analysis (EDA) Refinement
**Author:** KHAWLA BENNACEUR
**Document Purpose:** To document the architectural decisions, domain-specific logic validation, and advanced prompt-engineering collaboration used to build the clinical and financial data models.

---

## 📋 Table of Contents
1. Core Architectural Strategy (File Decoupling)
2. Clinical Logic Validation & Refactoring
3. Synthetic Data Discrepancies & Resolutions
4. AI Collaboration Blueprint (Human-in-the-Loop)
5. Impact on Downstream Reporting (Power BI Preparation)

---

## 1. Core Architectural Strategy (File Decoupling)
* **The Initial State:** The project phase began with a single planned EDA file (`03_clinical_financial_eda.sql`).
* **The Strategic Shift:** To optimize data granularity, prevent visual noise, and implement engineering best practices, the analysis was decoupled into two specialized domain files:
  * `03_clinical_analytics_eda.sql`: Focused on patient risk stratification, treatment velocity, and operational capacity.
  * `04_financial_analytics_eda.sql`: Focused on insurance revenue cycles, billing variances, and hospital cost-per-day metrics.

## 2. Clinical Logic Validation & Refactoring
*This section highlights my analytical pushback and refusal to accept generic data structures.*

* **The Challenge:** Initial automated baselines attempted to classify clinical risk by blending diagnostic outcomes and medication fields into a single high-granularity matrix. This caused severe data dilution (too many rows per case) and included arbitrary restrictions (e.g., limiting symptomatic care profiles to only infections and injuries).
* **The Critical Analysis:** I identified that any medical condition (such as chronic diabetes or acute respiratory failure) could present a "Normal" baseline lab entry snapshot at admission while still requiring urgent symptomatic care or preventative pathways.
* **The Engineering Resolution:** I overrode the initial structure to develop a **Universal Clinical Profiling Matrix** using a windowed CTE framework:
  ```sql
  CASE 
      WHEN test_results = 'Abnormal' AND length_of_stay > 7 THEN 'Acute / Severe Case'
      WHEN test_results = 'Abnormal' AND length_of_stay <= 7 THEN 'Acute / Well-Managed Case'
      WHEN test_results = 'Normal' AND length_of_stay <= 3 THEN 'Symptomatic / Acute Preventative Care'
      ELSE 'Routine Management / Stable Chronic'
  END AS clinical_profile
  ```

## 3. Synthetic Data Discrepancies & Resolutions
* **The Nature of the Data:** Acknowledgment that the source dataset utilizes synthetic generative patterns, which can introduce clinical anomalies (such as "Infections" presenting completely normal test results).
* **Analytical Treatment:** Rather than altering raw values or forcing unnatural medical rules, the anomalies were contextualized operationally. Normal-testing acute entries are strategically mapped as localized or early-stage outpatient pathways, transforming a dataset limitation into a sophisticated data-stratification feature.

## 4. AI Collaboration Blueprint (Human-in-the-Loop)
* **Scaffolding vs. Architecture:** AI was leveraged as an accelerated execution partner to quickly scaffold raw syntax structures, aggregate functions, and windowing configurations (`OVER (PARTITION BY...)`).
* **The Human-in-the-Loop Safeguard:** I served as the primary system architect and domain expert—rigorously reviewing every query for business logic alignment, diagnosing `ONLY_FULL_GROUP_BY` SQL mode violations, and forcing code iterations until the data boundaries were bulletproof.

## 5. Impact on Downstream Reporting (Power BI Preparation)
* **Granularity Control:** By separating macro risk trends from micro medication performance metrics into two clean SQL views, the backend logic dramatically simplifies dashboard filter actions (slicers).
* **Dashboard Readiness:** The resulting output yields clean, predictable categorical dimensions, preventing visual clutter in Power BI matrix visuals and ensuring an indisputable, logical data narrative for stakeholders.

## 6. Financial Root-Cause Analysis: Overturning the "False" Expense Rank
*This section highlights a major analytical discovery made during the refactoring of Phase 3 financial metrics.*

* **The Challenge:** The initial baseline query attempted to evaluate financial risk using a generic "Super-User" outlier list (Top 10% highest billing individual patients). This failed to provide macro-level business insights regarding which clinical pathologies truly drain hospital resources on a daily operational level.
* **The Refactoring Shift:** I overrode the individual tracking query to engineer two side-by-side pathology benchmarking models: 
  1. *Query A:* Total/Average Billing per Medical Condition (Macro Burden).
  2. *Query B:* Average Cost per Day vs. Average Length of Stay (Financial Intensity Velocity).

### 🔍 Key Discovery: The Asthma vs. Alzheimer's Paradox
By keeping both queries to cross-examine the data, I uncovered a critical operational anomaly that would have severely skewed hospital budgeting if left unnoticed:

* **The Alzheimer’s Illusion:** In the total billing query, Alzheimer’s ranked as the 3rd most expensive condition. However, the root-cause query revealed this was a **"false financial expense rank."** The daily intensity rank dropped Alzheimer's to 7th place. The high total bill was driven purely by an extreme **Average Length of Stay (54.4 days)** of low-intensity room occupancy, rather than expensive active medical interventions.
* **The Asthma Reality:** Conversely, Asthma jumped to **2nd place in real daily intensity**, despite having a remarkably short **Average Length of Stay (3.5 days)**. This proves that Asthma care is highly intense, requiring expensive acute medications, rapid diagnostic lab tests, or respiratory therapies upfront.

### 🎨 Strategic Downstream Reporting (Power BI Implementation)
Instead of deleting the first query, I preserved both models. In the upcoming Power BI dashboard, this will be visualized using a **Scatter Plot Matrix (X-Axis: Length of Stay, Y-Axis: Cost per Day)**. This explicitly allows hospital executives to instantly separate "High-Occupancy/Low-Cost" chronic conditions from "Low-Occupancy/High-Cost" acute emergency interventions.
