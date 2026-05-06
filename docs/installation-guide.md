# Installation Guide

## Prerequisites Checklist

Before importing, confirm you have:

- [ ] Power Platform environment with Dataverse enabled
- [ ] System Administrator role in the target environment
- [ ] Copilot Studio license (or trial) assigned to your account
- [ ] Power Automate license (per-flow or per-user)
- [ ] Microsoft 365 license (for email/Teams connectors)
- [ ] Chosen your deployment tier: [Tier 1 (Field Service)](tier1-field-service.md) or [Tier 2 (Dataverse-only)](tier2-dataverse-only.md)
- [ ] A shared mailbox created for warranty emails (recommended: `warranty@yourdomain.com`)
- [ ] A designated approver email address for claim approvals

---

## Step 1 — Import the Solution

1. Navigate to [make.powerapps.com](https://make.powerapps.com) and select your target environment.
2. Go to **Solutions** → **Import solution**.
3. Upload `solution/WarrantyandClaimOperations_v1.0.0.14.zip`.
4. Click **Next**.
5. On the **Connection References** screen, create or select connections for each connector:

   | Connection Reference | Connector | Action |
   |---|---|---|
   | Office 365 Outlook | shared_office365 | Sign in with your M365 account |
   | Dataverse | shared_commondataserviceforapps | Auto-created |
   | Microsoft Teams | shared_teams | Sign in |
   | SharePoint | shared_sharepointonline | Sign in |
   | Approvals | shared_approvals | Sign in |
   | Copilot Studio | shared_microsoftcopilotstudio | Sign in |

6. On the **Environment Variables** screen, enter your values:

   | Variable | Value |
   |---|---|
   | `cr74e_ApproverEmail` | Email of the approvals manager |
   | `cr74e_Warrantymailbox` | Your shared warranty mailbox |
   | `cr74e_YourORGURL` | `https://yourorg.crm.dynamics.com` |

7. Click **Import** and wait for completion (~5–10 minutes).

---

## Step 2 — Post-Import: Turn On Flows

After import, Power Automate flows are **off by default**. Turn them on in this order:

1. **Claim Routing Automation** — Turn on first (core routing logic)
2. **When a Claim is added or modified** — Triggers agent notifications
3. **New Claims Notifications** — Sends Teams alerts
4. **Create Warranty Claim** — Called by agents
5. **Request Manager Approval for Claim** — Approval workflow
6. **Capture each incoming and outgoing email** — Email thread tracking
7. **When a new email arrives for a warranty claim** — Email-to-claim trigger
8. **Send Shipping Label** — Outbound shipping
9. **Customer Interaction Agent Flow** — Agent-triggered interactions

> ⚠️ **Note:** Flows 6–9 require the shared mailbox to be configured first. If the mailbox doesn't exist yet, leave them off until it's ready.

---

## Step 3 — Publish Copilot Studio Agents

1. Navigate to [copilotstudio.microsoft.com](https://copilotstudio.microsoft.com).
2. Open each agent and click **Publish**:
   - Customer Warranty Advisor
   - Warranty Claim Processing for Email
   - Customer Interaction Agent
   - Technician Warranty Entry Helper
   - Warranty Checker
   - Copilot in Power Apps - Warranty Claim
3. For the **Warranty Checker** (Auth Mode: External/Public), configure the authentication settings under **Settings → Security** if you want to embed it on an external portal.

---

## Step 4 — Configure the Warranty Mailbox

The `Warranty Claim Processing for Email` agent monitors a shared mailbox. To configure:

1. In your Microsoft 365 admin center, ensure the shared mailbox exists (e.g., `warranty@yourdomain.com`).
2. Grant the account used by the Office 365 connector **Full Access** to the shared mailbox.
3. In the `When a new email arrives for a warranty claim` flow, verify the mailbox address matches your `cr74e_Warrantymailbox` environment variable.
4. Turn the flow **On**.

---

## Step 5 — Verify the Model-Driven App

1. In your Power Platform environment, open **Apps**.
2. Locate the **Warranty and Claim Operations** model-driven app.
3. Open a test claim record and verify the embedded Copilot agent loads correctly.
4. Check that the custom pages (Service Center Receiving, Technician Claim Capture) open without errors.

---

## Step 6 — Load Reference Data

The following tables ship empty and need to be populated before use:

| Table | Recommended Starting Data |
|---|---|
| `cr74e_claimstatuses` | New, In Review, Approved, Rejected, Closed |
| `cr74e_rootcauses` | Manufacturing Defect, Shipping Damage, User Error, Unknown |
| `cr74e_departments` | Customer Service, Engineering, Logistics, Finance |

You can use the provided [post-install script](../scripts/post-install.ps1) to seed this data automatically.

---

## Troubleshooting

### Flow fails with "Connection not authorized"
Re-authenticate the connection in Power Automate → **Connections**. Connection references must be reauthorized by the user whose account will run the flow.

### Copilot agent shows "Not configured"
Ensure the `Customer Interaction Agent Flow` is turned on — the agent's Actions depend on it.

### Emails not creating claims
Check that:
1. The `Warranty Claim Processing for Email` agent is **Published**
2. The `When a new email arrives for a warranty claim` flow is **On**
3. The shared mailbox has proper delegated access for the connector account

### D365 Field Service table errors (Tier 2 installs)
If you see errors referencing `msdyn_warranty` or `msdyn_customerasset`, you are running a Tier 2 (Dataverse-only) environment. Follow the [Tier 2 setup guide](tier2-dataverse-only.md) to use the custom table replacements.
