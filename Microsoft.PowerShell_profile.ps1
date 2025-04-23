# Import-Module posh-git
# oh-my-posh init pwsh | Invoke-Expression
# Set-PoshPrompt -Theme marcduiker

Function notepad([string] $path) {Start notepad++ "$path"}
Set-Alias -Name np -Value notepad

## az 

Function azsignedin { Write-Output "> az ad signed-in-user show --query id -o tsv" ; az ad signed-in-user show --query id -o tsv }
 

## Git

Function gitFetch {git fetch}
Set-Alias -Name gf -Value gitFetch

Function gitStatus {git status}
Set-Alias -Name gs -Value gitStatus

Function commit() {
	param([Parameter(Mandatory=$true)] [string] $message )
	git commit -m $message
	}
Function gitCommitAll() {
	$m = $args -join " "
	git commit -am $m
	}

Set-Alias -Name gca -Value gitCommitAll
Function up() {
	gitCommitAll
	git push
	}
Function gitCheckout() { git checkout $args }
Set-Alias -Name gco -Value gitCheckout

Function gitAddAll {Write-Output "> git add -A ; git reset -- .\src\Project\EWII.Website\Web.config ; git status"; git add -A ; git reset -- .\src\Project\EWII.Website\Web.config ; git status}
Set-Alias -Name gaa -Value gitAddAll

Function gitLog {Write-Output "> git log --oneline"; git log --oneline}
Set-Alias -Name gll -Value gitLog

Function current {git rev-parse --abbrev-ref HEAD}

Function syncMain {Write-Output "> git fetch origin main:main -v"; git fetch origin main:main -v}
Set-Alias -Name sync -Value syncMain

## Navigation

Function goToEwii {cd C:\ewii}
Set-Alias -Name ewii -Value goToEwii

Function goToTools{cd C:\Tools}
Set-Alias -Name tools -Value goToTools

Function goToFrontend {cd C:\ewii\EWII.Website\src\Frontend}
Set-Alias -Name fe -Value goToFrontend

Function goToEwiiWebsite {cd C:\ewii\EWII.Website\ ; git status}
Set-Alias -Name web -Value goToEwiiWebsite

Function openMostResentWebsiteLog { Start notepad++ ( gci C:\ewii\EWII.Website\src\Project\EWII.Website\App_Data\Log | select -last 1 | % { $_.FullName })}
Set-Alias -Name weblog -Value openMostResentWebsiteLog

Function goHome {cd ~}
Set-Alias -Name ~ -Value goHome

Function goUp {cd ..}
Set-Alias -Name .. -Value goUp

Function goToLearning {cd C:\Users\MadsBorumEngell\Learning}
Set-Alias -Name learn -Value goToLearning

Function openAdvent {code 'C:\Users\MadsBorumEngell\OneDrive - Immeo P S\Documents\adventofcode'}
Set-Alias -Name advent -Value openAdvent

Function goToDesktop {cd ~/Desktop/}
Set-Alias -Name desktop -Value goToDesktop

Function openProfile { start notepad++ C:\Users\MadsBorumEngell\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1}
Set-Alias -Name profile -Value openProfile



Function ewiicode {
	# Get a list of folders in a specific directory
	$folderPath = "C:\ewii"
	$folders = Get-ChildItem -Path $folderPath -Directory | Select-Object Name
	# Display the list in a grid view
	$selectedFolder = $folders | Out-GridView -Title "Select a Folder" -OutputMode Single 
	# Output the selected folder (optional)
	if ($selectedFolder) {
		Write-Output "Selected folder: $($selectedFolder.Name)"
	} else {
		Write-Output "No folder selected."
	}
	$path = "$($folderPath)\$($selectedFolder.Name)"
	Write-Output $path

	$options = @('Visual Studio', 'Vs Code', 'Explorer')
	$selectedOption = $options | Out-GridView -Title "Select how to open the repos" -OutputMode Single 
	if ($selectedOption -eq 'Visual Studio'){
		Write-Output "opening Visual Studio at $($path)"
		Get-ChildItem -Path $path -Filter "*.sln" | Invoke-Item
	} elseif ($selectedOption -eq 'Vs Code') {
		Write-Output "opening Vs code at $($path)"
		code $path
	} elseif ($selectedOption -eq 'Explorer') {
		Write-Output "opening Explorer at $($path)"
		explorer $path
	}
}

function openVisualStudio {
  $slnFiles = Get-ChildItem -Path . -Filter *.sln -File

  if ($slnFiles.Count -eq 1) {
    $slnFilePath = $slnFiles[0].FullName
    Write-Host "Opening solution file: $slnFilePath"
    Start-Process $slnFilePath
  }
  elseif ($slnFiles.Count -gt 1) {
    Write-Host "Multiple solution files found:"
    for ($i = 0; $i -lt $slnFiles.Count; $i++) {
      Write-Host "[$i] $($slnFiles[$i].Name)"
    }
    $choice = Read-Host "Enter the number of the solution to open"
    if ($choice -match '^\d+$' -and $choice -ge 0 -and $choice -lt $slnFiles.Count) {
      $slnFilePath = $slnFiles[$choice].FullName
      Write-Host "Opening solution file: $slnFilePath"
      Start-Process $slnFilePath
    }
    else {
      Write-Host "Invalid selection."
    }
  }
  else {
    Write-Host "No solution files found in the current directory."
  }
}

Function sln_old { gci -Filter "*.sln" | Invoke-Item}
Set-Alias sln openVisualStudio

## Tools

Function buildWithNpm {cd C:\ewii\EWII.Website\src\Frontend; npm run build-local;}
Set-Alias -Name build -Value buildWithNpm

Function runAsAdmin {Start-Process powershell -Verb runAs}
Set-Alias -Name admin -Value runAsAdmin

Function runMitIdAuthenticator {cd C:\Tools\MitIdAuthenticator; .\MitIdAuthenticator.exe @args}
Set-Alias -Name mitid -Value runMitIdAuthenticator

Function openMitIdAuthenticatorSettings {cd C:\Tools\MitIdAuthenticator; np mitid_users.txt}
Set-Alias -Name mitid-settings -Value openMitIdAuthenticatorSettings

Function runMitIdAuthenticatorApp {cd C:\Tools\MitIdAuthenticatorApp; .\MitIdAuthenticatorApp.exe}
Set-Alias -Name mitidapp -Value runMitIdAuthenticatorApp

Function z_jwtfunc {
    Param($env , $i, $kundenummer)
    $url = ""
	if (($env -ne $null) -and ($env -eq "kunde")) {
        $url = "https://idpewiiselfservicetb2c.b2clogin.com/IDPEWIISelfservicetB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_CUSTOMERSERVICEIMPERSONATIONKUNDENUMMER&client_id=dc6deefb-97f1-4663-ac94-00ddd86692f1&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login&ImpersonatedKundenummer=$kundenummer"
    } elseif (($env -ne $null) -and ($env -eq "a")) {
        $url = "https://idpewiiselfserviceab2c.b2clogin.com/IDPEWIISelfserviceaB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_ERHVERV_SIGNUP_SIGNIN&client_id=8d4868de-cedb-4f0e-9ddf-1d90f9de577a&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"
    } else {
        $url = "https://idpewiiselfservicetb2c.b2clogin.com/IDPEWIISelfservicetB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_ERHVERV_SIGNUP_SIGNIN&client_id=dc6deefb-97f1-4663-ac94-00ddd86692f1&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"
    }
    if ($i -ne $null -and ($i -eq "i")) {
        $url = $url + " --incognito"
    } 
    Start-Process -FilePath Chrome -ArgumentList $url
}

# Function jwtprivat {
	# Start-Process -FilePath Chrome -ArgumentList "https://netseidbroker.pp.mitid.dk/login?ReturnUrl=%2Fconnect%2Fauthorize%2Fcallback%3Fcausation_id%3D34ddf440-7c86-4758-8d37-f59ff4422f1c%26X-Correlation-Id%3D912668ec-a1e6-408a-967c-3eaeb7b1bba2%26request%3DeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL25ldHNlaWRicm9rZXIucHAubWl0aWQuZGsvIiwiaXNzIjoiYzM1Mzg3NjEtOGQ2Yi00MzRiLTk5YzAtNDEzODU1NWZjN2FkIiwiZXhwIjoxNzE0NDg1MTI1LCJpYXQiOjE3MTQ0ODM5MjUsIm5iZiI6MTcxNDQ4MzkyNSwiY2xpZW50X2lkIjoiYzM1Mzg3NjEtOGQ2Yi00MzRiLTk5YzAtNDEzODU1NWZjN2FkIiwicmVkaXJlY3RfdXJpIjoiaHR0cHM6Ly9wcC5uZXRzZWlkYnJva2VyLmRrL29wL3NpZ25pbi1vaWRjLW1pdGlkIiwicmVzcG9uc2VfdHlwZSI6ImNvZGUiLCJzY29wZSI6Im9wZW5pZCBtaXRpZCIsImNvZGVfY2hhbGxlbmdlIjoiTnhUS0xPNzQzbHJrV2lGVFJEbnRsejB5YWVpcDdsbmg4YVdHSkF2Rm4wVSIsImNvZGVfY2hhbGxlbmdlX21ldGhvZCI6IlMyNTYiLCJyZXNwb25zZV9tb2RlIjoiZm9ybV9wb3N0IiwiZmxvd19pZCI6IjFiZWY3NGZhLWI5NmEtNGQ2MS05ODcyLTRlNjMxODQ2MTdiYiIsInN0YXRlVmFsdWVzIjoie1wiY2xpZW50X2lkXCI6XCI3ZDBlYmQ0Zi1iZmM4LTQ2MGEtYTllNC01NThiYzQxNWQwMWJcIixcImJyb2tlcl9zZWN1cml0eV9jb250ZXh0XCI6XCIwODg5NkU0MkVGRDFBNThDQTYyNUZBRTdDNDI3MUQyRjdCRjYxOEY2OTVFREVEQzUyMjI3QzhERjQ4RUIxNDE5XCIsXCJpc19zaWduZWRfcmVxdWVzdFwiOmZhbHNlLFwibGFuZ3VhZ2VcIjpcImRhXCIsXCJpZHBfcGFyYW1zXCI6bnVsbCxcInJlcXVlc3RlZF9vcF9zY29wZXNcIjpudWxsLFwibmViX2Zsb3dfdHlwZVwiOlwic3RhbmRhcmRcIixcImlzX2NvbnNlbnRcIjpmYWxzZSxcImlkZW50aXR5X3Byb3ZpZGVyc1wiOltcIm1pdGlkXCJdLFwib3JnYW5pemF0aW9uX3R5cGVcIjpcIlByaXZhdGVcIixcImlzX2J1c2luZXNzXCI6ZmFsc2UsXCJub25jZVwiOlwicnF4YVdzcW9Kendpekd1SUdLMlxcdTAwMkI1UT09XCJ9In0.T6MzSxqgX-79-lhiuuOFgk24LPaWJICcCDnfOuGff_8%26state%3DCfDJ8KOh_oNCS51BnREjhdnLDsEN3Zb0KT5Cb3cgi4_suMZonbDeH-C0yQIDenkhaMt-E-iy-5vq57ElKs9P9gImSWswChP13HoHVSMfkN15PTEiLOlOQx6h8XtiSm2ppHGPZskAAVG7wYNXVrkFGjim5y5K0jtdFj53lB6QHbN3zg-h%26x-client-SKU%3DID_NET8_0%26x-client-ver%3D7.5.0.0%26client_id%3Dc3538761-8d6b-434b-99c0-4138555fc7ad%26response_type%3Dcode"
# }



Function Impersonate {
	param(
	[Parameter(Mandatory=$true)]
	$type, 
	[Parameter(Mandatory=$true)]
	$param)
    $url = ""
	if (($type -ne $null) -and ($type -eq "kunde" -or $type -eq "k")) {
        $url = "inte.ewii.dk/impersonate/kunde/login-oidc?kundenummer=$param"
    } elseif (($type -ne $null) -and ($type -eq "individ" -or $type -eq "i")){
		$url = "inte.ewii.dk/impersonate/login-oidc?individid=$param"
	}
	Start-Process -FilePath Chrome -ArgumentList $url
}

Function openApplicationInsight {
	param(
	[Parameter(Mandatory=$true)] $bc, 
	[Parameter(Mandatory=$true)] $env
	)
	# Param($bc, $env)
	$env = if ($env -eq $null) { "t" } else { $env }

	$rg = "bc-"
	$rg += if ($bc -eq "") { "shared-" } else { $bc + "-" }
	$rg += if ($env -eq "") { "t" } else { $env }
	
	$resource = "bc-"
	$resource += if ($bc -eq "") { } else { $bc + "-" } 
	$resource += if ($env -eq "") { "t" } else { $env }
	
	echo "Opening application insight for ${resource}"
	$url = "https://portal.azure.com/#@trefor.onmicrosoft.com/resource/subscriptions/f94c4c2f-0be9-4ba9-84fa-54bf3e1c1fe6/resourceGroups/${rg}-rg/providers/Microsoft.Insights/components/${resource}-apin/overview"
	Start-Process -FilePath msedge -ArgumentList $url
}
Set-Alias apin -Value openApplicationInsight

Function episerverApin {
	param(
	[Parameter(Mandatory=$false)] $env = "inte"
	)
	$inteurl = "https://portal.azure.com/#@episerver.net/resource/subscriptions/9f34964d-d03f-4b80-a3f7-618590da2b89/resourceGroups/ewas01mstrt0h1ginte/providers/microsoft.insights/components/ewas01mstrt0h1ginte/overview"
	$prepurl = "https://portal.azure.com/#@episerver.net/resource/subscriptions/9f34964d-d03f-4b80-a3f7-618590da2b89/resourceGroups/ewas01mstrt0h1gprep/providers/microsoft.insights/components/ewas01mstrt0h1gprep/overview"
	$produrl = "https://portal.azure.com/#@episerver.net/resource/subscriptions/9f34964d-d03f-4b80-a3f7-618590da2b89/resourceGroups/ewas01mstrt0h1gprod/providers/microsoft.insights/components/ewas01mstrt0h1gprod/overview"
	
	$url = $inteurl
	
	if (($env -ne $null) -and ($env -eq "prep")) {
		$url = prepurl
	} elseif (($env -ne $null) -and ($env -eq "prod")){
		$url = $produrl
	}
	echo "Opening application insight for episerver ${env}"
	Start-Process -FilePath msedge -ArgumentList $url
}

Function GPTTopProp {Get-ChatGPTResponse -TopProbabilityMass 0.5 }
Set-Alias ?? -Value GPTTopProp

## Individ authorization

$idpUrlSbPrivat_t = "https://idpewiiselfservicetb2c.b2clogin.com/IDPEWIISelfservicetB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_INDIVID_SIGNUP_SIGNIN&client_id=dc6deefb-97f1-4663-ac94-00ddd86692f1&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"
$idpUrlApp_t = "https://idpewiiselfservicetb2c.b2clogin.com/IDPEWIISelfservicetB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_INDIVID_SIGNUP_SIGNIN_APP&client_id=dc6deefb-97f1-4663-ac94-00ddd86692f1&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"
$idpUrlSbPrivat_a = "https://idpewiiselfserviceab2c.b2clogin.com/IDPEWIISelfserviceaB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_INDIVID_SIGNUP_SIGNIN&client_id=8d4868de-cedb-4f0e-9ddf-1d90f9de577a&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"
$idpUrlApp_a = "https://idpewiiselfserviceab2c.b2clogin.com/IDPEWIISelfserviceaB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_INDIVID_SIGNUP_SIGNIN_APP&client_id=8d4868de-cedb-4f0e-9ddf-1d90f9de577a&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"


Function f5 {
	param([Parameter(Mandatory=$false)] [string] $incognito = "" )
	$url = "https://localhost:8080"
	
	if ($incognito -eq "incognito"){
		$url = $url + " -inprivate"
	}
	Start-Process -filepath msedge -argumentlist $url
}

Function jwtSbPrivat {
	param([Parameter(Mandatory=$false)] [string] $env = "t" )
	$url = ""
	if ($env -eq "t"){
		Write-Host "Authorizing against test"
		$url = $idpUrlSbPrivat_t + " -inprivate"
	} elseif ($env -eq "a"){
		Write-Host "Authorizing against acceptance"
		$url = $idpUrlSbPrivat_a + " -inprivate"
	} else {
		Write-Host "Please behave..."
		return
	}
	Start-Process -FilePath msedge -ArgumentList $url
	# Start-Process -FilePath msedge -ArgumentList "https://idpewiiselfservicetb2c.b2clogin.com/IDPEWIISelfservicetB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_INDIVID_SIGNUP_SIGNIN&client_id=dc6deefb-97f1-4663-ac94-00ddd86692f1&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"}
}
Function jwtAPP {	Start-Process -FilePath msedge -ArgumentList "https://idpewiiselfservicetb2c.b2clogin.com/IDPEWIISelfservicetB2C.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1A_INDIVID_SIGNUP_SIGNIN_APP&client_id=dc6deefb-97f1-4663-ac94-00ddd86692f1&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid&response_type=id_token&prompt=login"}


Function signaturgruppelinkAPP {Start-Process -FilePath msedge -ArgumentList "https://pp.netseidbroker.dk/op/connect/authorize?redirect_uri=https://localhost&scope=openid&response_type=code&idp_values=mitid&client_id=bea76d9f-6f9c-480c-9e13-304b8df13a7e"}

Function signaturgruppelinkSB {Start-Process -FilePath msedge -ArgumentList "https://pp.netseidbroker.dk/op/connect/authorize?redirect_uri=https://inte.ewii.dk&scope=openid&response_type=code&idp_values=mitid&client_id=7d0ebd4f-bfc8-460a-a9e4-558bc415d01b"}


Function timer {
	# Set the total duration for the timer in seconds
	$totalDuration = $args[0]  # Change this to your desired duration
	# Initialize variables
	$startTime = Get-Date
	$currentTime = $startTime
	$endTime = $startTime.AddSeconds($totalDuration)
	$lastPercentage = -1

	# Main loop
	while ($currentTime -lt $endTime) {
		# Calculate the percentage completed
		$percentage = [math]::Round((($currentTime - $startTime).TotalSeconds / $totalDuration) * 100)
		# Only update the display if the percentage has changed
		if ($percentage -ne $lastPercentage) {
			$elapsed = ($currentTime - $startTime).ToString("hh\:mm\:ss")
			Write-Progress -Activity "Timing $totalDuration seconds" -PercentComplete $percentage -Status "Running Timer" -CurrentOperation "Time Elapsed: $elapsed"
			$lastPercentage = $percentage
		}
		# Sleep for a short interval (e.g., 1 second)
		Start-Sleep -Seconds 1
		# Update the current time
		$currentTime = Get-Date
	}
	# Finish and clean up
	Write-Host "Timer completed."
	[System.Media.SystemSounds]::Hand.Play() 
}


Function GetLockingProcess {
	param([Parameter(Mandatory=$true)] [string] $FileOrFolderPath)
	IF((Test-Path -Path $FileOrFolderPath) -eq $false) {
    Write-Warning "File or directory does not exist."       
}
Else {
    $LockingProcess = CMD /C "openfiles /query /fo table | find /I ""$FileOrFolderPath"""
    Write-Host $LockingProcess
}
}

Function test {
	param([Parameter(Mandatory=$false)] [string] $env = "t" )
	
	if ($env -eq "t"){
		Write-Host "Authorizing against test"
	} elseif ($env -eq "a"){
		Write-Host "Authorizing against acceptance"
	} else {
		Write-Host "Please behave..."
	}
	
	Write-Host $env
  }