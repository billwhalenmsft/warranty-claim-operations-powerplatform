# Tier 1 — D365 Field Service Deployment

Use this guide if your customer has **D365 Field Service** licensing. The solution imports and runs as-is with no customization needed.

## Required Licenses

- D365 Field Service (per-user or per-app)
- Power Platform (Dataverse)
- Copilot Studio
- Microsoft 365

## Field Service Tables Used

This tier leverages native Field Service tables. These must exist in the environment before import:

| Table | Schema Name | Why It's Used |
|---|---|---|
| Customer Assets | `msdyn_customerasset` | Links warranty claims to specific serialized equipment |
| Customer Asset Categories | `msdyn_customerassetcategory` | Groups assets by product category |
| Warranties | `msdyn_warranty` | Native warranty period/coverage records |
| Product Inventory | `msdyn_productinventory` | Parts availability for repairs |
| Purchase Order Products | `msdyn_purchaseorderproduct` | Parts ordering for claim resolution |
| Purchase Order Receipt Products | `msdyn_purchaseorderreceiptproduct` | Receiving parts for repair |
| Work Orders | `msdyn_workorder` | Referenced for repair/service tracking |

## Verification Steps

Before importing the solution:

1. Open your environment and confirm **Field Service** is installed:
   - Navigate to **Apps** → look for **Field Service**
   - Or run: `pac solution list --environment <url>` and confirm `FieldService` appears

2. Confirm the above tables exist in **Tables** in your environment.

3. If Field Service isn't installed, either:
   - Install it from [AppSource](https://appsource.microsoft.com) (requires admin consent + license)
   - Switch to [Tier 2 (Dataverse-only)](tier2-dataverse-only.md)

## Import the Solution

Follow the standard [Installation Guide](installation-guide.md). No additional steps are required for Tier 1.

## Data Relationships (Field Service)

```
Product (product)
  └── Customer Asset (msdyn_customerasset)
        ├── Warranty (msdyn_warranty)
        └── Warranty Claim (cr74e_warrantyclaim)   ← custom
              ├── Customer Interactions (cr74e_customerinteraction)
              └── Email Thread Maps (cr74e_emailthreadmap)
```
