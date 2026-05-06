# Copilot Studio Agents

This solution includes 6 Copilot Studio agents at varying stages of completeness. Review the status of each before planning your deployment.

> **Knowledge Sources:** All agents originally contained customer-specific warranty PDF documents as knowledge sources. Those documents have been **removed** from this distribution. After import, open each agent in Copilot Studio and add your own product warranty documents under **Knowledge** to enable accurate warranty-related answers.

---

## Customer Warranty Advisor

**Schema name:** `cr74e_customerWarrantyAdvisor`  
**Auth:** Teams / Entra ID  
**Status:** ✅ Functional starter — extend topics and add knowledge sources

### Purpose
Customer-facing agent for warranty inquiries. Customers can:
- Look up warranty coverage by serial number or product
- Check claim status
- Submit a new warranty claim

### What's There
- 1 custom topic: Claim status / serial number lookup flow
- System topics (Greeting, Escalate, Fallback, etc.)
- Flow call to `Create Warranty Claim`

### What You'll Need to Add
- Your product warranty documents as knowledge sources (PDF, SharePoint, or website)
- Additional topics based on your claims process
- Any product-specific lookup logic

---

## Warranty Claim Processing for Email

**Schema name:** `cr74e_warrantyClaimProcessingForEmail`  
**Auth:** Teams / Entra ID  
**Trigger:** Shared mailbox monitor  
**Status:** ✅ Most functional out of the box — requires mailbox and flow config

### Purpose
Automatically processes inbound warranty emails. When a customer emails the warranty mailbox:
1. Agent parses the email for product, serial number, and issue description
2. Matches to an existing customer/account or creates a new contact
3. Creates a `cr74e_warrantyclaim` record
4. Sends an acknowledgment email to the customer
5. Routes the claim to the appropriate department

### What's There
- Email trigger topic with claim creation flow
- Acknowledgment email template topic
- Actions: `CreateWarrantyClaim`, `SendEmailV2`, `Teams channel post`

### Dependencies
- Shared mailbox configured and set in `cr74e_Warrantymailbox` environment variable
- `When a new email arrives for a warranty claim` flow must be **On**
- AI Builder plugin (`msdynaip_SummarizeClaimandWarrantyDetails`) used for data extraction

### What You'll Need to Add
- Knowledge sources with your warranty coverage documents
- Customize the acknowledgment email template for your brand

---

## Customer Interaction Agent

**Schema name:** `cr74e_customerInteractionAgent`  
**Auth:** Teams / Entra ID  
**Status:** ⚠️ Starter — 1 custom topic, needs additional topics and knowledge sources

### Purpose
Handles inbound customer inquiries. Acts as a general-purpose intake agent that:
- Captures customer contact and issue details
- Determines if the issue is warranty-related
- Routes to Warranty Advisor or human queue
- Logs interactions to `cr74e_customerinteractions`

### What's There
- 1 custom topic: Customer interaction / warranty claim capture
- System topics only beyond that

### What You'll Need to Add
- Your product warranty documents as knowledge sources
- Additional routing logic for your specific triage scenarios
- Integration with any ticketing or CRM system beyond basic Dataverse

---

## Warranty Checker

**Schema name:** `cr74e_warrantyChecker`  
**Auth:** External / No sign-in required (Auth Mode 3)  
**Status:** ✅ Most complete agent — embeddable widget ready to configure

### Purpose
Lightweight public-facing widget. Customers enter a serial number and see:
- Whether the product is under warranty
- Warranty expiration date
- How to file a claim

### What's There
- 2 custom topics: Create warranty claim, Root cause/rating flow
- Dataverse MCP Server actions for warranty lookup
- `SummarizeClaimandWarrantyDetails` AI Builder action
- Global variables: AccountName, ClaimGUID, Serial, SerialNumber

### Deployment Note
This agent uses **external auth (no sign-in)**. To embed on a public website:
1. In Copilot Studio → Settings → Channels → Custom website
2. Copy the embed snippet
3. Paste into your public warranty portal

### Security Note
Because this agent is unauthenticated, it should only surface non-PII warranty status data. Do not add topics that expose customer account details or claim histories.

### What You'll Need to Add
- Your own warranty document knowledge sources (customer-specific PDFs have been removed)

---

## Technician Warranty Entry Helper

**Schema name:** `cr74e_technicianEntryHelper`  
**Auth:** Teams / Entra ID  
**Audience:** Internal field service technicians  
**Status:** ⚠️ Scaffolding / starter — 1 custom topic, intended as a starting point only

### Purpose
Intended to guide technicians through warranty claim data entry. The topic structure is there as a starting point but this agent is **not ready to use without additional development**.

### What's There
- 1 custom topic: Product serial / warranty claim entry flow (basic)
- System topics

### What You'll Need to Build
- Topics for root cause selection, parts lookup, defect documentation
- Validation logic against your product serial registry (`cr74e_productserials`)
- Integration with `cr74e_partses` for line-item parts entry
- Mobile-optimized conversation design for field use

---

## Copilot in Power Apps - Warranty Claim

**Schema name:** `cr74e_bot555100`  
**Auth:** Teams / Entra ID  
**Channel:** Embedded in model-driven app  
**Status:** ❌ Minimal — system topics only, requires significant development

### Purpose
Intended as an assistant embedded in the model-driven Claims app for internal staff. In its current state it contains only system topics (Greeting, Escalate, Fallback, etc.) and has not been built out.

### What You'd Need to Build
- Topics for claim summarization, warranty lookup, email drafting
- Context awareness of the currently open claim record (via Power Apps component framework or app variables passed to the agent)
- Integration with the AI Builder summarization plugin
