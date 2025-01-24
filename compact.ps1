# Default ext4.vhdx location.
$ext4_location = "C:\Users\$Env:username\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"

$diskpart_instructions = @"
select vdisk file=$ext4_location
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@

# Variables for UI
$title = "Confirm"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)


$clearDockerData = $Host.UI.PromptForChoice(
    $title,
    "Do you want to clear docker data via sudo docker system prune?",
    $choices,
    1
)

if ($clearDockerData -eq 0) {
    Write-Host "Clear docker data..."
    wsl --exec sudo docker system prune -f
}

Write-Host "WSL shutdown..."
wsl --shutdown

$isNotDefault = $Host.UI.PromptForChoice(
    $title,
    "Are you not using Ubuntu or have you changed the ext4.vhdx file default location?",
    $choices,
    1
)

switch ($isNotDefault) {
    0 {
        $customExt4Location = Read-Host "Enter full location of your ext4.vhdx file"

        if (($customExt4Location -notlike "*.vhdx") -and !(Test-Path $customExt4Location)) {
            Write-Host "The file not found!"
        } else {
            $ext4_location = $customExt4Location
            $diskpart_instructions | diskpart
        }
    }
    1 {$diskpart_instructions | diskpart}
}

Read-Host "Press Enter to exit"
