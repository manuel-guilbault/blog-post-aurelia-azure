Param(
  [string] $ResourceGroup,
  [string] $StorageAccount,
  [string] $StorageContainer,
  [string] $Permission,
  [string] $ExportTo
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroup -Name $StorageAccount
$context = New-AzureStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $key[0].Value
$sasToken = New-AzureStorageContainerSASToken -Name $StorageContainer -Permission $Permission -Context $context -ExpiryTime (Get-Date).AddYears(100)
Write-Host "##vso[task.setvariable variable=$ExportTo]$sasToken"
