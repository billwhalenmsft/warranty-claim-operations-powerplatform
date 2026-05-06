# Power Automate Flows

Detailed reference for all 9 Power Automate flows in the solution.

---

## Claim Routing Automation

**Trigger:** Dataverse — When a row is added/modified (cr74e_warrantyclaims)  
**Connectors:** Dataverse  
**Key Logic:**
- Evaluates claim category, product type, and priority
- Updates the `cr74e_departments` lookup on the claim to route it
- Sets the initial `cr74e_claimstatus`

**No action required after install** — runs automatically when claims are created.

---

## Create Warranty Claim

**Trigger:** HTTP (called by Copilot Studio agents)  
**Connectors:** Dataverse, `msdyn_warranties` (Tier 1) / `cr74e_warrantyrecord` (Tier 2)  
**Key Logic:**
- Receives structured data from the agent (serial number, issue, customer)
- Looks up the matching warranty record
- Creates the `cr74e_warrantyclaim` record
- Returns the new claim ID and status to the agent

**⚠️ Tier 2 note:** Update the warranty lookup step to use `cr74e_warrantyrecord` instead of `msdyn_warranties`.

---

## Request Manager Approval for Claim

**Trigger:** Dataverse — When a row is modified (claim amount > threshold)  
**Connectors:** Dataverse, Approvals  
**Key Logic:**
- Checks claim value against the approval threshold
- Sends an Approvals request to the email in `cr74e_ApproverEmail` environment variable
- On approval: updates claim status to Approved, triggers shipping label flow
- On rejection: updates status, sends rejection email to customer

---

## When a Claim is added or modified

**Trigger:** Dataverse — When a row is added/modified  
**Connectors:** Dataverse, Copilot Studio  
**Key Logic:**
- Fires when claim status changes
- Sends event to the Customer Interaction Agent for proactive outreach if needed

---

## New Claims Notifications

**Trigger:** Dataverse — When a new high-priority claim is created  
**Connectors:** Dataverse, Microsoft Teams  
**Key Logic:**
- Posts a formatted adaptive card to a Teams channel
- Includes: claim number, customer name, product, issue summary, priority
- Channel is configured inside the flow action — update to your target channel after import

**Post-install action:** Update the Teams channel ID in the flow to point to your team's claims notification channel.

---

## Capture each incoming and outgoing email

**Trigger:** Dataverse — When an email row is added  
**Connectors:** Dataverse, Office 365 Outlook  
**Key Logic:**
- Monitors all email activity in Dataverse
- Matches emails to open warranty claims via `cr74e_emailthreadmaps`
- Creates `cr74e_emailthreadmatchlog` entries for audit trail

---

## When a new email arrives for a warranty claim

**Trigger:** Office 365 — New email in shared mailbox  
**Connectors:** Office 365 Outlook, Copilot Studio  
**Key Logic:**
- Triggers when an email arrives in the warranty shared mailbox
- Passes email content to the `Warranty Claim Processing for Email` agent
- Agent extracts claim data and creates/updates the claim record

**Pre-requisite:** Shared mailbox must be configured and connected before turning this flow on.

---

## Send Shipping Label

**Trigger:** Dataverse — Claim status changes to "Approved for Return"  
**Connectors:** Dataverse, SharePoint Online, Office 365 Outlook  
**Key Logic:**
- Retrieves the shipping label template from a SharePoint document library
- Merges customer address data into the template
- Emails the shipping label to the customer

**Post-install action:** Update the SharePoint site URL and document library path to point to your label template location.

---

## Customer Interaction Agent Flow

**Trigger:** Copilot Studio (HTTP from agent)  
**Connectors:** Dataverse, Copilot Studio  
**Key Logic:**
- Called by agents when a customer interaction needs to be logged
- Creates a `cr74e_customerinteraction` record linked to the relevant claim
- Returns confirmation to the agent
