# Power BI DAX measures

These DAX examples document the report calculations. The Warehouse SQL prepares the source facts, including billing gaps, payroll allocations, and SLA flags. See the [relationship settings](relationships.md) for how month and client filters reach those facts.

## Service Demand & Quality

The `Tickets Closed` example expresses the visual's sum of the Warehouse `IsClosed` flag under the active closure-date relationship. `USERELATIONSHIP` switches the other ticket measures below to the opening date. The SLA flags are `1` for met and `0` for missed, with blanks excluded from the average. Resolution hours convert the median recorded minutes to hours.

```dax
Tickets Closed =
SUM(FactTicket[IsClosed])

Tickets Opened =
CALCULATE(
    COUNTROWS(FactTicket),
    USERELATIONSHIP(DimDate[CalendarDate], FactTicket[CreatedDate])
)

First Response SLA % =
CALCULATE(
    AVERAGE(FactTicket[FirstResponseSlaMet]),
    USERELATIONSHIP(DimDate[CalendarDate], FactTicket[CreatedDate])
)

Resolution SLA % =
CALCULATE(
    AVERAGE(FactTicket[ResolutionSlaMet]),
    USERELATIONSHIP(DimDate[CalendarDate], FactTicket[CreatedDate])
)

Median Resolution Hours =
DIVIDE(
    CALCULATE(
        MEDIAN(FactTicket[ResolutionMinutes]),
        USERELATIONSHIP(DimDate[CalendarDate], FactTicket[CreatedDate])
    ),
    60
)

Survey Invitations =
COUNTROWS(FactSurvey)

Survey Responses =
SUM(FactSurvey[IsResponded])

Average CSAT =
CALCULATE(
    AVERAGE(FactSurvey[CsatScore]),
    FactSurvey[IsResponded] = 1
)

Survey Response Rate =
DIVIDE([Survey Responses], [Survey Invitations])
```

The customer satisfaction card shows the average rating out of five. The technician table applies a visual filter for named closing technicians.

## Client Contracts & Recovery Plan

Margins divide profit by the matching revenue total. The corrected-billing scenario uses the signed rate for all eligible workstations and holds modeled delivery costs fixed.

```dax
Managed Revenue =
SUM(FactManagedContractMonth[InvoicedRevenue])

Managed Gross Profit =
SUM(FactManagedContractMonth[ManagedGrossProfit])

Managed Gross Margin % =
DIVIDE([Managed Gross Profit], [Managed Revenue])

Billing Gap =
SUM(FactManagedContractMonth[BillingGap])

Gross Profit at Correct Billing =
SUM(FactManagedContractMonth[ManagedGrossProfitAtCorrectBilling])

Gross Margin at Correct Billing % =
DIVIDE(
    [Gross Profit at Correct Billing],
    SUM(FactManagedContractMonth[ExpectedRevenue])
)
```

## Business Performance

Company gross profit includes all delivery payroll. Operating profit subtracts overhead in the Warehouse. The project margin comparison uses the same project revenue for both calculations, with logged engineering labor in the direct margin and total engineering payroll in the department margin.

```dax
Company Revenue =
SUM(FactBusinessMonth[CompanyRevenue])

Company Gross Profit =
SUM(FactBusinessMonth[CompanyGrossProfit])

Operating Profit =
SUM(FactBusinessMonth[OperatingProfit])

Direct Project Margin % =
DIVIDE(
    SUM(FactBusinessMonth[DirectProjectGrossProfit]),
    SUM(FactBusinessMonth[ProjectRevenue])
)

Project Department Margin % =
DIVIDE(
    SUM(FactBusinessMonth[ProjectDepartmentGrossProfit]),
    SUM(FactBusinessMonth[ProjectRevenue])
)
```
