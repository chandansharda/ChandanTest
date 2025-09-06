# ProfitLossExpandableView

A reusable, expandable view showing a portfolio's **profit & loss** details.

---

## Architecture
This project uses **MVVM+C**:
- **Model:** `ProfitLossExpandableView.Model` represents portfolio values.
- **View:** `ProfitLossExpandableView` handles UI (table + footer).
- **ViewModel:** Provides the `Model` and handles expand/collapse logic.
- **Coordinator:** Handles navigation and interactions (not shown here).

---

## Features
- Expand/collapse portfolio details.
- Displays:
  - Current Value
  - Total Investment
  - Today's Profit & Loss
  - Total Profit & Loss
- Diffable data source with dynamic table height.
- Rounded top corners with shadow.
- Footer with expand button.

---

<video controls width="600"> <source src=".ChandanTask/Media/Simulator%20Screen%20Recording%20-%20iPhone%2016%20Pro%20-%202025-09-06%20at%2013.17.42.mp4" type="video/mp4"> Your browser does not support the video tag. </video> ```
