<#
.SYNOPSIS
    Post-install helper for Warranty & Claim Operations solution.
    Seeds reference data (claim statuses, root causes, departments).

.PARAMETER OrgUrl
    Your Dataverse org URL, e.g. https://yourorg.crm.dynamics.com

.EXAMPLE
    .\post-install.ps1 -OrgUrl "https://yourorg.crm.dynamics.com"
#>
param(
    [Parameter(Mandatory)]
    [string]$OrgUrl
)

$ErrorActionPreference = 'Stop'

# --- Auth: uses current az login / pac auth ---
$token = az account get-access-token --resource $OrgUrl --query accessToken -o tsv
$headers = @{ Authorization = "Bearer $token"; 'Content-Type' = 'application/json'; 'OData-MaxVersion' = '4.0'; 'OData-Version' = '4.0' }
$api = "$OrgUrl/api/data/v9.2"

function Invoke-DataversePost($table, $body) {
    $url = "$api/$table"
    try {
        Invoke-RestMethod $url -Method POST -Headers $headers -Body ($body | ConvertTo-Json -Depth 5)
        Write-Host "  ✅ Created: $($body.cr74e_name)" -ForegroundColor Green
    } catch {
        Write-Warning "  ⚠️  Skipped (may already exist): $($body.cr74e_name)"
    }
}

Write-Host "`n=== Seeding Claim Statuses ==="
@('New', 'In Review', 'Pending Approval', 'Approved', 'Rejected', 'Closed', 'On Hold') | ForEach-Object {
    Invoke-DataversePost 'cr74e_claimstatuseses' @{ cr74e_name = $_ }
}

Write-Host "`n=== Seeding Root Causes ==="
@('Manufacturing Defect', 'Shipping Damage', 'Installation Error', 'User Error', 'Normal Wear', 'Unknown / Under Investigation') | ForEach-Object {
    Invoke-DataversePost 'cr74e_rootcauseses' @{ cr74e_name = $_ }
}

Write-Host "`n=== Seeding Departments ==="
@('Customer Service', 'Engineering / QA', 'Logistics / Returns', 'Finance / Approvals', 'Field Service') | ForEach-Object {
    Invoke-DataversePost 'cr74e_departmentses' @{ cr74e_name = $_ }
}

Write-Host "`n✅ Reference data seeding complete." -ForegroundColor Cyan
Write-Host "Next steps:"
Write-Host "  1. Verify data in make.powerapps.com → Tables"
Write-Host "  2. Update environment variables (ApproverEmail, Warrantymailbox, YourORGURL)"
Write-Host "  3. Turn on Power Automate flows (see docs/installation-guide.md)"
Write-Host "  4. Publish Copilot Studio agents"
