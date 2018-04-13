Param(
  [string] $ApiKey,
  [string] $ApiSecret,
  [string] $Domain,
  [string] $IPAddress,
  [string] $TargetDomain
)

$domainParts = $Domain.split('.')
if ($domainParts.Length -eq 2) {
  if ($IpAddress -eq "") {
    Write-Error "Domain '$Domain' is an A record, so IPAddress argument is required."
    return
  }
  $rootDomain = $Domain
  $recordType = "A"
  $recordName = "@"
  $payload = "[{""ttl"": 3600, ""data"": ""$IPAddress""}]"
} elseif ($domainParts.Length -ge 2) {
  if ($TargetDomain -eq "") {
    Write-Error "Domain '$Domain' is a CName record, so TargetDomain argument is required."
  }
  $subDomainParts = $domainParts[0..($domainParts.Length - 3)]
  $rootParts = $domainParts | Select-Object -Skip ($domainParts.Length - 2)

  $rootDomain = $rootParts -join "."
  $recordType = "CNAME"
  $recordName = $subDomainParts -join "."
  $payload = "[{""ttl"": 600, ""data"": ""$TargetDomain"" }]"
} else {
  Write-Error "Domain '$Domain' is invalid."
  return
}

$headers = @{ "Authorization" = "sso-key $($ApiKey):$ApiSecret"; "Content-Type" = "application/json" }
Invoke-WebRequest -Uri "https://api.godaddy.com/v1/domains/$rootDomain/records/$recordType/$recordName" -Method PUT -Headers $headers -Body $payload
