# Power BI model relationships

[View the semantic model diagram](semantic-model.png)

The Power BI model uses Direct Lake tables from the Fabric Warehouse. Shared date and client dimensions let the report filter facts at different levels of detail.

## Fact tables

| Table | One row represents |
|---|---|
| `FactTicket` | The latest available version of a ticket |
| `FactSurvey` | One survey invitation, with a score when the customer responded |
| `FactManagedContractMonth` | One client agreement term in one service month |
| `FactContractRenewalSnapshot` | One agreement term in effect on October 31, 2026 |
| `FactProject` | One project |
| `FactBusinessMonth` | One company reporting month |

## Relationship settings

All relationships below are **one-to-many**, with a **single filter direction** from the dimension to the fact table.

| Dimension key (`1`) | Fact key (`*`) | Status |
|---|---|---|
| `DimClient[ClientId]` | `FactTicket[ClientId]` | Active |
| `DimClient[ClientId]` | `FactSurvey[ClientId]` | Active |
| `DimClient[ClientId]` | `FactManagedContractMonth[ClientId]` | Active |
| `DimClient[ClientId]` | `FactContractRenewalSnapshot[ClientId]` | Active |
| `DimClient[ClientId]` | `FactProject[ClientId]` | Active |
| `DimClosingActor[ClosingActorKey]` | `FactTicket[ClosingActorKey]` | Active |
| `DimClosingActor[ClosingActorKey]` | `FactSurvey[ClosingActorKey]` | Active |
| `DimDate[CalendarDate]` | `FactTicket[ClosedDate]` | Active |
| `DimDate[CalendarDate]` | `FactTicket[CreatedDate]` | Inactive. Activated by opened-ticket and SLA measures. |
| `DimDate[CalendarDate]` | `FactSurvey[ClosedDate]` | Active |
| `DimDate[CalendarDate]` | `FactManagedContractMonth[MonthStart]` | Active |
| `DimDate[CalendarDate]` | `FactProject[MonthStart]` | Active |
| `DimDate[CalendarDate]` | `FactBusinessMonth[MonthStart]` | Active |

- The service page counts ticket closures by the recorded closer and closure month. Ticket opening, SLA, and elapsed resolution measures use the opening month. Survey measures use the ticket closure month.
- The renewal table uses a fixed reporting snapshot and has a client relationship. The monthly company fact reports company-wide results, including shared payroll and overhead, and has a date relationship.
- The report's **Month** slicers use `DimDate[YearMonth]`. Trend charts retain the full history through Power BI visual interaction settings.
