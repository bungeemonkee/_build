# Get arguments
param (
	[string]$project
)

# Get the results file inside the project
$file="$project\TestResults\*.trx"
$file=(Resolve-Path $file)

# Get the upload url
$url="https://ci.appveyor.com/api/testresults/mstest/$($env:APPVEYOR_JOB_ID)"

Write-Output "Uploading file: $file"
Write-Output "  To: $url"

# Upload results to AppVeyor
$wc = New-Object 'System.Net.WebClient'
$wc.UploadFile($url, $file)