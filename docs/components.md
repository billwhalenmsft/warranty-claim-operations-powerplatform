# Component Inventory

Complete list of every component in the **Warranty and Claim Operations** solution (v1.0.0.14, Gold environment).

---

## Copilot Studio Agents (Bots)

| Internal Name | Display Name | Auth Mode | Purpose |
|---|---|---|---|
| cr74e_customerWarrantyAdvisor | Customer Warranty Advisor | Teams / Entra (2) | Customer-facing agent for warranty status lookups and self-service claim submission |
| cr74e_warrantyClaimProcessingForEmail | Warranty Claim Processing for Email | Teams / Entra (2) | Monitors shared warranty mailbox; auto-creates and routes claims from inbound emails |
| cr74e_customerInteractionAgent | Customer Interaction Agent | Teams / Entra (2) | Handles inbound inquiries, captures issue details, routes to correct team |
| cr74e_technicianEntryHelper | Technician Warranty Entry Helper | Teams / Entra (2) | Guides service technicians through claim data entry in the field |
| cr74e_warrantyChecker | Warranty Checker | External / Public (3) | Lightweight serial-number warranty lookup; embeddable on external portals |
| cr74e_bot555100 | Copilot in Power Apps - Warranty Claim | Teams / Entra (2) | Embedded assistant inside the model-driven app for claims staff |

---

## Canvas Apps

| Internal Name | Display Name | Purpose |
|---|---|---|
| cr74e_servicecenterreceivingandevaluation | Service Center Receiving & Evaluation | Intake app for service centers to log incoming products for warranty assessment |
| cr74e_technicianclaimcapture | Technician Claim Capture | Mobile-optimized app for field technicians to capture claim details on-site |
| cr74e_warrantyclai28de0ed7defaultcommandlibra | Warranty Claim Command Library | Default command bar library embedded in the model-driven app |

---

## Power Automate Flows

| Flow Name | Trigger | Connectors | Purpose |
|---|---|---|---|
| Claim Routing Automation | Dataverse row change | Dataverse | Routes new/updated claims to the correct department based on category and rules |
| Create Warranty Claim | HTTP (from agent) | Dataverse, msdyn_warranties | Creates a new warranty claim record; called by Copilot Studio agents |
| Request Manager Approval for Claim | Dataverse row change | Dataverse, Approvals | Sends approval request to manager when claim exceeds threshold |
| When a Claim is added or modified | Dataverse trigger | Dataverse, Copilot Studio | Triggers agent notification on claim state changes |
| New Claims Notifications | Dataverse trigger | Dataverse, Teams | Posts a Teams channel message when a new high-priority claim is created |
| Capture each incoming and outgoing email | Dataverse trigger | Dataverse, Office 365 Outlook | Logs email activity to the claim's interaction timeline |
| When a new email arrives for a warranty claim | Shared mailbox trigger | Office 365 Outlook, Copilot Studio | Detects inbound warranty emails; triggers the email processing agent |
| Send Shipping Label | Dataverse trigger | Dataverse, SharePoint, Office 365 Outlook | Generates and emails a return shipping label when a claim is approved |
| Customer Interaction Agent Flow | Copilot Studio trigger | Dataverse, Copilot Studio | Called by agents to log customer interaction records |

---

## Custom Dataverse Tables

| Display Name | Schema Name | Type | Key Relationships |
|---|---|---|---|
| Warranty Claims | cr74e_warrantyclaims | Custom | → account, contact, product, msdyn_customerasset/cr74e_asset |
| Claim Statuses | cr74e_claimstatuses | Custom | → cr74e_warrantyclaims |
| Customer Interactions | cr74e_customerinteractions | Custom | → cr74e_warrantyclaims, account, contact |
| Departments | cr74e_departments | Custom | → cr74e_warrantyclaims (routing) |
| Email Thread Maps | cr74e_emailthreadmaps | Custom | → cr74e_warrantyclaims, email |
| Email Thread Match Logs | cr74e_emailthreadmatchlogs | Custom | → cr74e_emailthreadmaps |
| Parts | cr74e_partses | Custom | → cr74e_warrantyclaims (line items) |
| Product Serials | cr74e_productserials | Custom | → product, account |
| Root Causes | cr74e_rootcauses | Custom | → cr74e_warrantyclaims |
| Users (custom) | cr74e_users | Custom | Maps Dataverse users to agent/tech roles |

---

## Standard Tables Referenced

These ship with every Dataverse environment — no license required beyond Dataverse:

- `account` (Accounts)
- `contact` (Contacts)
- `email` (Email Activities)
- `phonecall` (Phone Call Activities)
- `product` (Products catalog)
- `productassociation` (Product bundles)
- `productsubstitute` (Substitute products)

---

## AI Builder Plugins

| Plugin Name | Purpose |
|---|---|
| msdynaip_SummarizeClaimandWarrantyDetails | Summarizes claim details and warranty status for agent responses using AI Builder |
| msdynaip_Customprompt814202580558AM | Custom prompt for claim triage classification |

---

## Environment Variables

| Schema Name | Type | Default | Description |
|---|---|---|---|
| cr74e_ApproverEmail | Text | `test@test.com` | Email of the manager who approves claims |
| cr74e_Warrantymailbox | Text | `email@email.com` | Shared mailbox monitored for incoming warranty emails |
| cr74e_YourORGURL | Text | `https://YOURORG.crm.dynamics.com` | Dataverse org URL used in flow deep links |

---

## Web Resources

| Name | Type | Purpose |
|---|---|---|
| cr74e_windowsvgrepocom | SVG | Window/product icon for UI |
| cr74e_navigation_dashboard | SVG | Dashboard navigation icon |
| jdk_navigation_customer_asset_gear | SVG | Customer asset navigation icon |
| cr74e_navigation-wrench | SVG | Repair/technician navigation icon |
