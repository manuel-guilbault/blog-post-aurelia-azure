Param(
  [string] $ResourceGroup,
  [string] $StorageAccount,
  [string] $StorageContainer
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroup -Name $StorageAccount
$context = New-AzureStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $key[0].Value
$sasToken = New-AzureStorageContainerSASToken -Name $StorageContainer -Permission r -Context $context -ExpiryTime (Get-Date).AddYears(100)
return $sasToken
