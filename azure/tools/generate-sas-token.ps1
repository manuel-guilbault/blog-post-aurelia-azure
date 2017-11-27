Param(
  [string] $resourceGroup,
  [string] $storageAccount,
  [string] $storageContainer
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup -Name $storageAccount
$context = New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $key[0].Value
$sasToken = New-AzureStorageContainerSASToken -Name $storageContainer -Permission r -Context $context -ExpiryTime (Get-Date).AddYears(100)
return $sasToken
