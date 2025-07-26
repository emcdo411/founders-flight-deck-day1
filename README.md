# 🧭 Founder's Flight Deck – Day 1: Cross-Functional Mastery

**Inspired by IMD’s Foundations for Business Leadership**  
**Curated by: Erwin Maurice McDonald**  
_Program Goal: Simulate elite executive training for AI-powered strategy delivery._

> This dashboard app runs three parallel client simulations—Defense, Fintech, and Nonprofit—within a unified RShiny interface using SQL Server and R-based APIs.

---

## 🧰 Shields.io Badges

![R](https://img.shields.io/badge/R-4.4.0-blue)
![Shiny](https://img.shields.io/badge/Shiny-Dashboard-black)
![SQL_Server](https://img.shields.io/badge/SQL--Server-ODBC-lightgrey)
![Mermaid](https://img.shields.io/badge/Diagram-Mermaid-orange)
![Plumber](https://img.shields.io/badge/API-Plumber-green)
![License](https://img.shields.io/github/license/emcdo411/founders-flight-deck-day1)

---

## ⚙️ Tech Stack

![R](https://img.shields.io/badge/R-4.4.0-blue)
![Shiny](https://img.shields.io/badge/Shiny-Dashboard-black)
![SQL_Server](https://img.shields.io/badge/SQL--Server-ODBC-lightgrey)
![Plumber](https://img.shields.io/badge/API--Plumber-green)
![DT](https://img.shields.io/badge/DT-Tables-blueviolet)
![Plotly](https://img.shields.io/badge/Plotly-Interactive_Graphs-orange)
![ggplot2](https://img.shields.io/badge/ggplot2-Advanced_Charts-yellow)
![shinyWidgets](https://img.shields.io/badge/shinyWidgets-UI_Extensions-red)
![odbc](https://img.shields.io/badge/ODBC-Database_Connector-lightblue)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-blue)

---

## 🔗 Clickable Sections

- [🧭 Day 1 Objective](#project-intro)
- [📊 Sector Dashboards](#workflow-diagram)
- [🧪 Workflow Diagram](#workflow-diagram)
- [🖥️ Running Outside Localhost](#running-outside-localhost)
- [📁 Folder Layout](#folder-structure)
- [🔧 Deployment Notes](docs/deployment-notes.md)

---

## 🖥️ Running Outside Localhost

This app defaults to localhost but supports:

- Hosting via [shinyapps.io](https://www.shinyapps.io/)
- Reverse proxy via Nginx
- Containerization via Docker (future step)
- API exposure via `/api/plumber.R`

---

## 📈 Workflow Diagram (Mermaid)

```mermaid
graph TD
    SQL[SQL Server Tables] --> RShiny[RShiny App]
    RShiny --> UI[Interactive Dashboards]
    UI --> Defense[Defense Metrics]
    UI --> Fintech[Fintech Scores]
    UI --> Nonprofit[Nonprofit KPIs]
    RShiny --> API[Plumber API]
    API -->|JSON Endpoints| CI_CD[GitHub Actions CI/CD]
