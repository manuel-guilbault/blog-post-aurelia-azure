Param(
  [string] $ResourceGroup,
  [string] $ClientSecret,
  [string] $ClientIdVariable
)

$ErrorActionPreference = "Stop"

$identifierUri = "https://manuelguilbault.com/lets-encrypt-$ResourceGroup"

Write-Host "Fetching AD application with URI '$identifierUri'..."
$app = Get-AzureRmADApplication -IdentifierUri $identifierUri
if ($app -eq $null) {
  Write-Host "AD application not found. Creating..."
  $app = New-AzureRmADApplication -DisplayName "lets-encrypt-$ResourceGroup" -HomePage $identifierUri -IdentifierUris $identifierUri -Password $ClientSecret
  Write-Host "AD application $($app.ApplicationId) created."

  Write-Host "Creating AD service principal..."
  New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId
  Write-Host "AD service principal created."

  Write-Host "Sleeping 20 seconds to make sure new AD application is indexed..."
  Start-Sleep 20
} else {
  Write-Host "AD application $($app.ApplicationId) found."
}

Write-Host "Fetching AD role assignment..."
$roleAssignment = Get-AzureRmRoleAssignment -ResourceGroupName $ResourceGroup -ServicePrincipalName $app.ApplicationId.Guid -RoleDefinitionName contributor
if ($roleAssignment -eq $null) {
  Write-Host "AD role assignment not found. Creating..."
  $roleAssignment = New-AzureRmRoleAssignment -ResourceGroupName $ResourceGroup -ServicePrincipalName $app.ApplicationId.Guid -RoleDefinitionName contributor
  Write-Host "AD role assignment $($roleAssignment.RoleAssignmentId) created."
} else {
  Write-Host "AD role assignment $($roleAssignment.RoleAssignmentId) found."
}

Write-Host "Assigning AD application $($app.ApplicationId) to variable $ClientIdVariable."
Write-Host "##vso[task.setvariable variable=$ClientIdVariable]$($app.ApplicationId)"
