
#region Read sensitive variables from .env file
$content = Get-Content .\.env
foreach ($line in $content) {
    if ([string]::IsNullOrWhiteSpace($line)) {
        Write-Verbose "Skipping empty line"
        continue
    }

    #ignore comments
    if ($line.StartsWith("#")) {
        Write-Verbose "Skipping comment: $line"
        continue
    }

    $name = $line.Split('=')[0]
    $value = $line.Split('=')[1]
    if (Get-Variable -Name $name -ErrorAction SilentlyContinue) {
        Remove-Variable -Name $name
    }
    New-Variable -Name $name -Value $value
}
#endregion Read sensitive variables from .env file

#region Authenticate against the API using the admin account
$Body = @{
    Username = ${PORTAINER_USER}
    Password = ${PORTAINER_PASS}
}

$Params = @{
    Method      = "POST"
    Uri         = "${PORTAINER_URL}/api/auth"
    Body        = ($Body | ConvertTo-Json)
    ContentType = "application/json"
}
$PORTAINER_TOKEN = Invoke-RestMethod @Params

if ($null -ne $PORTAINER_TOKEN.jwt) {
    Write-Output "... success"
} else {
    Write-Output "Result: failed to login"
}
#endregion Authenticate against the API using the admin account

#region List all containers
$Header = @{
    "authorization" = "Bearer $($PORTAINER_TOKEN.jwt)"
}

$Body = @{
    "all" = "true"
}

$Parameters = @{
    Method      = "GET"
    Uri         = "${PORTAINER_URL}/api/endpoints/1/docker/containers/json"
    Headers     = $Header
    ContentType = "application/json"
    Body        = ($Body | ConvertTo-Json)
}
Invoke-RestMethod @Parameters
#endregion List all containers

#region List endpoints
$Header = @{
    "authorization" = "Bearer $($PORTAINER_TOKEN.jwt)"
}

$Body = @{
}

$Parameters = @{
    Method      = "GET"
    Uri         = "${PORTAINER_URL}/api/endpoints"
    Headers     = $Header
    ContentType = "application/json"
    Body        = ($Body | ConvertTo-Json)
}
Invoke-RestMethod @Parameters
#endregion List endpoints

#region Deploy a new stack
$Header = @{
    "authorization" = "Bearer $($PORTAINER_TOKEN.jwt)"
}

$Body = @"
{
    "Name": "home-medialab",
    "RepositoryURL": "https://github.com/cviorel/home-medialab",
    "RepositoryReferenceName": "refs/heads/main",
    "ComposeFilePathInRepository": "docker-compose.yml",
    "RepositoryAuthentication": true,
    "RepositoryUsername": "${GIT_USER}",
    "RepositoryPassword": "${GIT_TOKEN}",
    "Env": [
        {
            "name": "PGID",
            "value": "${PGID}"
        },
        {
            "name": "PUID",
            "value": "${PUID}"
        },
        {
            "name": "TZ",
            "value": "${TZ}"
        },
        {
            "name": "CLOUDFLARE_API_KEY",
            "value": "${CLOUDFLARE_API_KEY}"
        },
        {
            "name": "CLOUDFLARE_ZONE",
            "value": "${CLOUDFLARE_ZONE}"
        },
        {
            "name": "NORDVPN_COUNTRY",
            "value": "${NORDVPN_COUNTRY}"
        },
        {
            "name": "NORDVPN_USER",
            "value": "${NORDVPN_USER}"
        },
        {
            "name": "NORDVPN_PASS",
            "value": "${NORDVPN_PASS}"
        }
    ]
}
"@

$Parameters = @{
    Method      = "POST"
    Uri         = "${PORTAINER_URL}/api/stacks?type=2&method=repository&endpointId=1"
    Headers     = $Header
    ContentType = "application/json"
    Body        = $Body
}
Invoke-RestMethod @Parameters
#endregion Deploy a new stack

#region List stacks
$Body = @{
}

$Parameters = @{
    Method      = "GET"
    Uri         = "${PORTAINER_URL}/api/stacks"
    Headers     = $Header
    ContentType = "application/json"
    Body        = ($Body | ConvertTo-Json)
}
$response = Invoke-RestMethod @Parameters
if ($null -ne $($response.Id)) {
    Write-Output ":: Stack ID: $($response.Id)"
}
#endregion List stacks

#region Delete stack
$stackId = 38
$Parameters = @{
    Method      = "DELETE"
    Uri         = "${PORTAINER_URL}/api/stacks/${stackId}"
    Headers     = $Header
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters
#endregion Delete stack
