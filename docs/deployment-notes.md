# 📈 Founder's Flight Deck – Workflow Diagram

```mermaid
graph TD
    SQL[SQL Server Tables] --> RShiny[RShiny App]
    RShiny --> UI[Interactive Dashboards]
    UI --> Defense[Defense Metrics]
    UI --> Fintech[Fintech Scores]
    UI --> Nonprofit[Nonprofit KPIs]
    RShiny --> API[Plumber API]
    API -->|JSON Endpoints| CI_CD[GitHub Actions CI/CD]
```
