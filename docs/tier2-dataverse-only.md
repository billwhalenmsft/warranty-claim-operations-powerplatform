# Tier 2 — Dataverse-Only Deployment (No Field Service)

Use this guide if your customer does **not** have D365 Field Service licensing. This tier replaces all `msdyn_*` Field Service tables with custom Dataverse tables that ship with the solution.

> ⚠️ **Status:** Tier 2 requires an additional solution layer (`WarrantyClaimOps_DataverseOnly_v1.x.x.zip`) that replaces table references. This is tracked as a future release — see [GitHub Issues](https://github.com/billwhalenmsft/warranty-claim-operations-powerplatform/issues) to follow progress or contribute.

---

## Required Licenses

- Power Platform (Dataverse enabled — any paid plan)
- Copilot Studio
- Microsoft 365
- **No D365 Field Service required**

---

## Custom Table Replacements

The following custom tables replace their Field Service equivalents:

| Replaces (Field Service) | Custom Table Name | Schema Name | Notes |
|---|---|---|---|
| `msdyn_customerasset` | Asset | `cr74e_asset` | Serialized equipment record |
| `msdyn_customerassetcategory` | Asset Category | `cr74e_assetcategory` | Product/equipment groupings |
| `msdyn_warranty` | Warranty Record | `cr74e_warrantyrecord` | Coverage period, terms, status |
| `msdyn_productinventory` | Parts Inventory | `cr74e_partsinventory` | Warehouse parts stock levels |
| `msdyn_purchaseorderproduct` | Purchase Order Line | `cr74e_purchaseorderline` | Parts procurement lines |

---

## Custom Table Schemas

### cr74e_asset (replaces msdyn_customerasset)

| Column | Type | Required | Description |
|---|---|---|---|
| cr74e_name | Text (100) | Yes | Asset name / description |
| cr74e_serialnumber | Text (50) | Yes | Unique serial number |
| cr74e_productid | Lookup → product | No | Linked product record |
| cr74e_accountid | Lookup → account | No | Customer/owner account |
| cr74e_installdate | Date | No | Installation date |
| cr74e_assetcategoryid | Lookup → cr74e_assetcategory | No | Asset category |
| cr74e_status | Choice | Yes | Active, Decommissioned, Under Repair |

### cr74e_warrantyrecord (replaces msdyn_warranty)

| Column | Type | Required | Description |
|---|---|---|---|
| cr74e_name | Text (200) | Yes | Warranty name / description |
| cr74e_assetid | Lookup → cr74e_asset | Yes | Covered asset |
| cr74e_accountid | Lookup → account | No | Warranty holder (customer) |
| cr74e_providerid | Lookup → account | No | Warranty provider (manufacturer) |
| cr74e_startdate | Date | Yes | Coverage start date |
| cr74e_enddate | Date | Yes | Coverage end date |
| cr74e_warrantystatus | Choice | Yes | Active, Expired, Voided, Pending |
| cr74e_coverageterms | Multiline Text | No | Coverage description / exclusions |
| cr74e_claimlimit | Currency | No | Maximum claim value |

### cr74e_assetcategory (replaces msdyn_customerassetcategory)

| Column | Type | Required | Description |
|---|---|---|---|
| cr74e_name | Text (100) | Yes | Category name |
| cr74e_description | Multiline Text | No | Category description |
| cr74e_parentcategoryid | Lookup → cr74e_assetcategory | No | Parent category (hierarchy) |

---

## Flows That Need Updating for Tier 2

The following flows reference Field Service tables and must be updated for Tier 2:

| Flow | Table Reference to Replace | Replacement |
|---|---|---|
| Create Warranty Claim | `msdyn_warranties` lookup | `cr74e_warrantyrecord` lookup |
| Claim Routing Automation | Any asset category filters | `cr74e_assetcategory` |
| When a Claim is added or modified | `msdyn_customerasset` | `cr74e_asset` |

---

## Data Relationship (Tier 2)

```
Product (product) — standard table
  └── Asset (cr74e_asset)  ← custom
        ├── Warranty Record (cr74e_warrantyrecord)  ← custom
        └── Warranty Claim (cr74e_warrantyclaim)    ← custom
              ├── Customer Interactions (cr74e_customerinteraction)
              └── Email Thread Maps (cr74e_emailthreadmap)
```

---

## Contributing a Tier 2 Solution

The Tier 2 variant is a community contribution opportunity. The work involves:

1. Creating the custom tables listed above in a new unmanaged solution
2. Updating the 3 flows listed to use the custom table lookups
3. Exporting and adding `WarrantyClaimOps_DataverseOnly.zip` to the `solution/` folder
4. Opening a PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.
