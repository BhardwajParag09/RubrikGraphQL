#Save Service account downloaded file.
$ServiceAccount = Get-Content ".\parag.json" |ConvertFrom-Json

#Create custom header
$headers = @{
"Content-Type" = "application/json"
}

#Payload to retrieve access token
$body = @{
 'client_id' = ($ServiceAccount.client_id)
 'client_secret' = ($ServiceAccount.client_secret)
}

$body = $body | ConvertTo-Json


#Get access token
$response = Invoke-RestMethod -Body $body -Headers $headers -Method Post -Uri $($ServiceAccount.access_token_uri)

## Access Token Complete

$bearerToken = $response.access_token
$headers = @{
"Authorization" = "Bearer $bearerToken"
"Content-Type" = "application/json"
}

$data=(Get-Content -Raw ./query)

$variable=(Get-Content -Raw ./variables)

$body = @{"query" = $data; "variables" = $variable}

$result = Invoke-RestMethod -Method Post -Uri "https://rubrik-support.my.rubrik.com/api/graphql" -Headers $headers -Body ($body | ConvertTo-Json)

Write-Output ($result | ConvertTo-Json -Depth 100)
