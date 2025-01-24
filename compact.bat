@ECHO off
SETLOCAL EnableDelayedExpansion

:: Set default ext4 location.
SET ext4_location=C:\Users\%USERNAME%\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx


CHOICE /M "Do you want to clear docker data (via sudo docker system prune)?"

IF %ERRORLEVEL% == 1 (
    ECHO Clear docker data...
    wsl --exec sudo docker system prune -f
)


ECHO WSL shutdown...
wsl --shutdown


CHOICE /M "Are you not using Ubuntu or have you changed the ext4.vhdx file default location?"

IF %ERRORLEVEL% == 2 (
    (
        ECHO select vdisk file=%ext4_location%
        ECHO attach vdisk readonly
        ECHO compact vdisk
        ECHO detach vdisk
        ECHO exit
    ) | diskpart
)

IF %ERRORLEVEL% == 1 (
    ECHO Enter full location of your ext4.vhdx file:
    SET /P custom_location=

    :: Check is last 4 characters of filename == vhdx
    IF NOT !custom_location:~-4! == vhdx (
        ECHO Wrong file format!
        ECHO Press any button to close.
        PAUSE >nul
        EXIT
    )
    
    IF NOT EXIST !custom_location! (
        ECHO The file not found!
    ) ELSE (
        SET ext4_location=!custom_location!
        (
            ECHO select vdisk file=%ext4_location%
            ECHO attach vdisk readonly
            ECHO compact vdisk
            ECHO detach vdisk
            ECHO exit
        ) | diskpart
    )
)

ECHO Press any button to close.
PAUSE >nul
