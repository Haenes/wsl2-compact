@ECHO off

wsl --exec docker system prune -f
wsl --shutdown
(
    ECHO select vdisk file=C:\Users\%USERNAME%\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx
    ECHO attach vdisk readonly
    ECHO compact vdisk
    ECHO detach vdisk
    ECHO exit
) | diskpart
