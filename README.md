# wsl2-compact
A repository that contains batch and powershell scripts designed to automate or, as minimum,\
simplify the process of compressing virtual disks storing Linux distros for WSL2.

There are two types of scripts here in case it's not possible to use, for example, .ps1, but you can use .bat.\
I would recommend using .bat scripts, just because they are easier to run.

## Manual compression
1) Batch:
   Run compress.bat as admin and follow instructions;
2) Powershell:
   Run powershell as admin, specify the path to the compress.ps1 script and follow instructions;
   > If "...cannot be loaded because running scripts is disabled on this system..." error occured: check [this](#error-1).

## How to automate the process?
> If you aren't using Ubuntu or change default location of ext4.vhdx file then\
> you need to change full path to file in auto script:
>  - .bat: line 6, ECHO select vdisk file=C:\Users\\%USERNAME%\custom\location\ext4.vhdx
>  - .ps1: line 2, select vdisk file=C:\Users\\$Env:username\custom\location\ext4.vhdx

> Also note that the docker data cleanup lines are UNCOMMENTED (the cleaning will be done).
>  - If you do not want to clear this data, or if your docker commands require sudo then\
>    delete these commands or comment them (for .bat use ::, for .ps1 use # at the beginning of the line).
>  - If you are satisfied with cleaning docker data, but docker commands require specifying sudo and,\
>    accordingly, a password, see this [official guide](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
1) Open task scheduler;
2) "Action" -> "Create new task"
3) In "General" tab set name of the task and check checkbox "Run with highest privileges"
> Highest privileges is needed because without them diskpart won't work.
4) In "Triggers" tab set when you want to script running
5) In "Actions" tab click "Create" -> "Discover"
6) Now you need to specify what you want to run:
   - If you want to use .bat script -> select script
   - If you want to use .ps1 script you should specify powershell.exe with additional args:
     - Program: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
     - Additional arguments: `-executionpolicy bypass -file C:\full\path\to\script.ps1`
> If your account does not have a password, then there may be an empty password or insufficient permissions error.\
> Check [this](#error-2) out to  fix the error.
7) Click "OK" two times and that's it!

To check if everything is working, double-click on the created task in the active tasks tab -> Right click -> Execute.


## Possible errors and their solutions
<a name="error-1"></a>
1) When you decide to manually run the .ps1 script, the following error may occur:\
   `"File *script path* cannot be loaded because running scripts is disabled on this system.`\
   `For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170."`\
   The solution is to <ins>change the ExecutionPolicy</ins>.

   To change the policy for the CURRENT powershell process ONLY, enter\
   `Set-ExecutionPolicy Bypass -Scope Process -Force` command in shell.

   The reason for the policy change is that Windows does not allow running .ps1 scripts by default,\
   especially those downloaded from the Internet. By specifying one of these directives, you can run the script.
   > Please note that we are changing the policy only for the current powershell process.\
   > This means that by closing and reopening powershell, we will have to change the policy again.
<a name="error-2"></a>
2) The second error may occur when creating a task in the scheduler if you do not have a password set.\
   There are at least two possible solutions:
     - Set a password and enter it
     - If you do not want to set a password, you can change the local policy.

   Solution 2 will be described below (Win10):
   - If you have the Windows Pro version:
     - `Win + R` -> gpedit.msc to open the local Group Policy editor and follow the chain below
     - `Computer Configuration -> Windows Configuration -> Security Settings -> Local Policies -> Security Settings`.
     - In the right column, find the policy `Accounts: allow the use of empty passwords only during console login.`
     - Double-click to it -> `Disabled` -> Save changes -> Done
   - Otherwise, we need to change register
     - `Win + R` -> regedit
     - Go to location `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa`
     - In the right column of the editor, find the `LimitBlankPasswordUse` parameter and change its value from 1 to 0
     - Reboot the system -> Done
