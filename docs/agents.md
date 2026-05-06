# Copilot Studio Agents

Detailed guide for each of the 6 Copilot Studio agents included in the solution.

---

## Customer Warranty Advisor

**Schema name:** `cr74e_customerWarrantyAdvisor`  
**Auth:** Teams / Entra ID  
**Channel:** Microsoft Teams, model-driven app

### Purpose
Customer-facing agent for warranty inquiries. Customers can:
- Look up warranty coverage by serial number or product
- Check claim status
- Submit a new warranty claim
- Get return shipping instructions

### Key Topics
- Warranty lookup by serial number
- Claim status check
- Submit new claim
- Escalate to human agent

### Flows Called
- `Create Warranty Claim`
- `Customer Interaction Agent Flow`

---

## Warranty Claim Processing for Email

**Schema name:** `cr74e_warrantyClaimProcessingForEmail`  
**Auth:** Teams / Entra ID  
**Trigger:** Shared mailbox monitor

### Purpose
Automatically processes inbound warranty emails. When a customer emails the warranty mailbox:
1. Agent parses the email for product, serial number, and issue description
2. Matches to an existing customer/account or creates a new contact
3. Creates a `cr74e_warrantyclaim` record
4. Sends an acknowledgment email to the customer
5. Routes the claim to the appropriate department

### Dependencies
- Shared mailbox configured and set in `cr74e_Warrantymailbox` environment variable
- `When a new email arrives for a warranty claim` flow must be **On**

### AI Capability
Uses the `msdynaip_SummarizeClaimandWarrantyDetails` AI Builder plugin to extract structured data from freeform email text.

---

## Customer Interaction Agent

**Schema name:** `cr74e_customerInteractionAgent`  
**Auth:** Teams / Entra ID

### Purpose
Handles inbound customer inquiries not covered by other agents. Acts as a general-purpose intake agent that:
- Captures customer contact and issue details
- Determines if the issue is warranty-related
- Routes to Warranty Advisor or human queue as appropriate
- Logs all interactions to `cr74e_customerinteractions`

---

## Technician Warranty Entry Helper

**Schema name:** `cr74e_technicianEntryHelper`  
**Auth:** Teams / Entra ID  
**Audience:** Internal field service technicians

### Purpose
Helps technicians capture warranty claim data accurately in the field. Guides the user through:
- Identifying the product and serial number
- Documenting the defect or failure mode
- Selecting root cause from the `cr74e_rootcauses` table
- Choosing the correct parts from `cr74e_partses`
- Submitting the completed claim for review

---

## Warranty Checker

**Schema name:** `cr74e_warrantyChecker`  
**Auth:** External / No sign-in required (Auth Mode 3)  
**Channel:** Embeddable widget (direct line)

### Purpose
Lightweight public-facing widget. Customers enter a serial number and immediately see:
- Whether the product is under warranty
- Warranty expiration date
- How to file a claim

### Deployment Note
This agent uses **external auth (no sign-in)**. It can be embedded on a public website via Direct Line. To get the embed code:
1. In Copilot Studio → Settings → Channels → Custom website
2. Copy the embed snippet
3. Paste into your public warranty portal or product registration page

### Security Note
Because this agent is unauthenticated, it should only return non-PII warranty status data. Do not add topics that expose customer account details or claim histories.

---

## Copilot in Power Apps - Warranty Claim

**Schema name:** `cr74e_bot555100`  
**Auth:** Teams / Entra ID  
**Channel:** Embedded in model-driven app

### Purpose
Assistant embedded in the model-driven Claims app for internal staff. Helps claims processors:
- Quickly summarize a claim's history
- Look up related warranty coverage
- Draft response emails to customers
- Get next-step recommendations based on claim status

### Note
This agent is context-aware of the current claim record when used inside the model-driven app via the embedded experience.
