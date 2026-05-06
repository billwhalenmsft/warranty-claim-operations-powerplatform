# Data Model Reference

## Core Relationship Diagram

```
┌──────────────┐     ┌─────────────────────┐
│   account    │────▶│  cr74e_productserial │
│  (standard)  │     │  (serial registry)  │
└──────────────┘     └──────────┬──────────┘
        │                       │
        │              ┌────────▼─────────┐
        │              │   msdyn_warranty  │  ← Tier 1 (Field Service)
        │              │   cr74e_warranty  │  ← Tier 2 (Custom)
        │              └────────┬─────────┘
        │                       │
        └────────────────────┐  │
                             ▼  ▼
                    ┌────────────────────┐
                    │ cr74e_warrantyclaim │
                    │  (core claim rec)  │
                    └────────┬───────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
┌──────────────────┐ ┌──────────────┐ ┌──────────────────┐
│cr74e_customerint │ │cr74e_partses │ │cr74e_emailthread │
│   eraction       │ │(line items)  │ │     map          │
└──────────────────┘ └──────────────┘ └──────────────────┘
```

## Warranty Claim Table Schema (cr74e_warrantyclaims)

This is the core table. Key columns:

| Column | Type | Notes |
|---|---|---|
| cr74e_name | Text | Auto-generated claim number |
| cr74e_claimstatusid | Lookup → cr74e_claimstatuses | Current status |
| cr74e_accountid | Lookup → account | Customer account |
| cr74e_contactid | Lookup → contact | Primary contact |
| cr74e_productid | Lookup → product | Product under warranty |
| cr74e_serialnumber | Text | Product serial number |
| cr74e_issuedate | Date | Date issue was first reported |
| cr74e_issuedescription | Multiline Text | Customer-reported problem |
| cr74e_rootcauseid | Lookup → cr74e_rootcauses | Diagnosed root cause |
| cr74e_departmentid | Lookup → cr74e_departments | Assigned handling department |
| cr74e_approvalstatus | Choice | Pending, Approved, Rejected |
| cr74e_claimvalue | Currency | Estimated repair/replacement cost |
| cr74e_warrantyid | Lookup → msdyn_warranty or cr74e_warrantyrecord | Linked warranty |
| cr74e_assetid | Lookup → msdyn_customerasset or cr74e_asset | Asset (Tier 1/2) |
| cr74e_dayssincereceipt | Calculated | Days since claim was received (formula column) |

## Claim Status Flow

```
New → In Review → Pending Approval → Approved → Shipped/Closed
                                   → Rejected → Closed
                     ↑
               (automatic via
                Routing flow)
```

## Email Threading Architecture

The solution tracks all email correspondence against claims using two tables:

- **cr74e_emailthreadmap** — Maps an email thread ID to a claim record
- **cr74e_emailthreadmatchlog** — Audit log of every email matched, with confidence score and match method

This enables the `Warranty Claim Processing for Email` agent to correctly associate replies in an email thread to the right claim even when the customer doesn't include a claim reference number.
