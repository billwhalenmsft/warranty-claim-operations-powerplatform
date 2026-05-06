# Warranty & Claim Operations — Power Platform Accelerator

![Power Platform](https://img.shields.io/badge/Power%20Platform-Dataverse-blue) ![Copilot Studio](https://img.shields.io/badge/Copilot%20Studio-6%20Agents-purple) ![License](https://img.shields.io/badge/license-MIT-green)

A production-ready **Warranty & Claims Management accelerator** built on Microsoft Power Platform. Includes Copilot Studio AI agents, Canvas Apps, Power Automate flows, and custom Dataverse tables — deployable in as little as a few hours.

---

## 🚀 What's Included

| Component Type | Count | Details |
|---|---|---|
| Copilot Studio Agents | 6 | Customer-facing, technician, email processing, Warranty Checker |
| Canvas Apps | 3 | Service Center Receiving, Technician Claim Capture, Command Library |
| Power Automate Flows | 9 | Routing, approvals, email, shipping, notifications |
| Custom Dataverse Tables | 11 | Claims, interactions, parts, serials, root causes, and more |
| Environment Variables | 3 | Org URL, approver email, warranty mailbox |
| AI Builder Plugins | 2 | Claim summarization, custom prompts |

---

## 🏗️ Deployment Tiers

This accelerator supports **two deployment configurations** based on your licensing:

### Tier 1 — D365 Field Service (Full)
Uses native Field Service tables: `msdyn_warranty`, `msdyn_customerasset`, `msdyn_productinventory`. Best for customers already licensed for D365 Field Service.

→ [Full Field Service Setup Guide](docs/tier1-field-service.md)

### Tier 2 — Dataverse / Power Apps Only
Replaces Field Service tables with custom equivalents (`cr74e_asset`, `cr74e_warrantyrecord`). Works with any Dataverse environment — no Field Service license required.

→ [Dataverse-Only Setup Guide](docs/tier2-dataverse-only.md)

---

## 📋 Prerequisites

### Required for Both Tiers
- Power Platform environment (Dataverse enabled)
- **Copilot Studio license** (for AI agents)
- **Power Automate** (per-flow or per-user plan)
- Microsoft 365 license (for email, Teams, SharePoint connectors)

### Additional for Tier 1
- **D365 Field Service license** (for msdyn_warranty, msdyn_customerasset tables)

---

## ⚡ Quick Start

```
1. Choose your tier (Field Service vs. Dataverse-only)
2. Import the solution ZIP into your environment
3. Set the 3 environment variables
4. Reconnect the 5 Power Automate connections
5. Publish the Copilot Studio agents
6. Configure the warranty mailbox (shared mailbox recommended)
```

See [Full Installation Guide](docs/installation-guide.md) for step-by-step instructions.

---

## 📁 Repository Structure

```
warranty-claim-operations-powerplatform/
├── solution/
│   └── WarrantyandClaimOperations_v1.0.0.14.zip   # Unmanaged solution (Gold)
├── docs/
│   ├── installation-guide.md                       # Step-by-step install
│   ├── tier1-field-service.md                      # Field Service config
│   ├── tier2-dataverse-only.md                     # Dataverse-only config
│   ├── components.md                               # Full component inventory
│   ├── flows.md                                    # Flow documentation
│   ├── agents.md                                   # Copilot Studio agents
│   └── data-model.md                               # Table schema reference
├── scripts/
│   └── post-install.ps1                            # Post-install helper
└── .gitignore
```

---

## 🤖 Copilot Studio Agents

| Agent | Auth | Purpose |
|---|---|---|
| **Customer Warranty Advisor** | Teams / Entra | Customer-facing warranty status & self-service |
| **Warranty Claim Processing for Email** | Teams | Monitors shared mailbox, auto-creates claims from emails |
| **Customer Interaction Agent** | Teams | Handles inbound customer inquiries, routes to claims |
| **Technician Warranty Entry Helper** | Teams | Guides field techs through claim data entry |
| **Warranty Checker** | External (Public) | Embeddable widget for external portals |
| **Copilot in Power Apps (Warranty)** | Teams | Embedded assistant inside model-driven app |

---

## 🔌 Connector Requirements

| Connector | Used By | License |
|---|---|---|
| Microsoft Dataverse | All flows | Dataverse (standard) |
| Office 365 Outlook | Email flows, shipping label | M365 |
| Microsoft Teams | New Claims Notifications | M365 |
| SharePoint Online | Send Shipping Label | M365 |
| Approvals | Manager Approval flow | Power Automate standard |
| Copilot Studio | Agent trigger flows | Copilot Studio |

---

## ⚙️ Environment Variables

| Variable | Type | Description |
|---|---|---|
| `cr74e_ApproverEmail` | Text | Email address of the claim approval manager |
| `cr74e_Warrantymailbox` | Text | Shared mailbox monitored for warranty claim emails |
| `cr74e_YourORGURL` | Text | Your Dataverse org URL (e.g. `https://yourorg.crm.dynamics.com`) |

---

## 📊 Custom Tables Included

| Table | Schema Name | Purpose |
|---|---|---|
| Warranty Claims | `cr74e_warrantyclaims` | Core claim record — status, parts, resolution |
| Claim Statuses | `cr74e_claimstatuses` | Configurable status picklist |
| Customer Interactions | `cr74e_customerinteractions` | Interaction log per claim |
| Departments | `cr74e_departments` | Routing/assignment departments |
| Email Thread Maps | `cr74e_emailthreadmaps` | Maps email threads to claims |
| Email Thread Match Logs | `cr74e_emailthreadmatchlogs` | Audit log for email-to-claim matching |
| Parts | `cr74e_partses` | Parts catalog for claim line items |
| Product Serials | `cr74e_productserials` | Serial number registry |
| Root Causes | `cr74e_rootcauses` | Configurable root cause codes |
| Users (custom) | `cr74e_users` | Agent/technician mapping |

---

## 🤝 Contributing

Pull requests welcome. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
