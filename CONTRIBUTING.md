# Contributing

Contributions are welcome! This accelerator is community-maintained.

## Ways to Contribute

- **Bug reports** — Open an issue with steps to reproduce
- **Feature requests** — Open an issue with the use case
- **Tier 2 solution** — Build the Dataverse-only variant (see [docs/tier2-dataverse-only.md](docs/tier2-dataverse-only.md))
- **Documentation improvements** — PRs for docs are always welcome
- **New flow variants** — E.g., a ServiceNow integration, a Salesforce sync, etc.

## Contribution Guidelines

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-improvement`
3. Make your changes
4. Test in a real Power Platform environment
5. Open a PR with a description of what you changed and why

## What NOT to Include in PRs

- Any `local.settings.json`, connection secrets, or API keys
- Customer-specific data, org URLs, or email addresses (use placeholder values)
- Solution files exported from customer environments
- Any `.msapp` files that contain customer-branded content

## Solution Export Guidelines

When exporting a new version of the solution ZIP:

1. Export as **unmanaged** from a clean Gold/template environment
2. Verify all environment variable defaults are sanitized (`test@test.com`, `https://YOURORG.crm.dynamics.com`)
3. Confirm no customer-specific data is embedded in Canvas App `.msapp` files
4. Name the file: `WarrantyandClaimOperations_vX.X.X.X.zip`
