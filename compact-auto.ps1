$diskpart_instructions = @"
select vdisk file=C:\Users\$Env:username\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@

wsl --exec docker system prune -f
wsl --shutdown
$diskpart_instructions | diskpart
