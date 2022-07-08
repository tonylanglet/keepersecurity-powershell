## :exclamation: UNOFFICAL module :exclamation:
### This is an unoffical Keeper Security powershell wrapper, some of the functionality is outdated but most of the functionality is still working. If you have any issues with this module/wrapper please report the issue here and not to the Keeper team. 

# Keeper Security with Powershell
Being able to use the Keeper security SDK with Powershell. The SDK is reliant on python and by calling python scripts in Powershell we'll be able to achieve the same result as the Keeper security cmd promt (KeeperCommander).

**_Be aware that having a UID using starting with '-' is not support in the powershell module but a solution for it is on its way_**

Keeper Security have developed a Powershell module which is WiP and have the most basic functionality ready to use. You are still welcome to use the wrapper I've created in case the PS Module isn't sufficent. [Keeper Commander Powershell Module](https://github.com/Keeper-Security/keeper-sdk-dotnet/tree/master/PowerCommander)

## Getting Started

### Prerequisites
* WinPython
* Environment variables
* KeeperCommander module for python
* Keeper security account

### Installing

#### WinPython
1. Download and install [WinPython](https://winpython.github.io/)

#### KeeperCommander Module
1. Open "WinPython Command Prompt"
2. Install Keeper commander with pip3:
```
$ pip3 --install keepercommander
```

#### Environment Variables
1. Right click "My Computer/This PC" choose properties
2. Click on "Advanced system settings" on the left hand-side
3. Click on "Environment Variables..." in the bottom right corner
4. In the first section named User varaibles for %username% Highlight the Variable named Path
5. Click on the button "Edit"
6. Click on the button New on the right-hand-side
7. Add the location of the python folder which is located inside the WinPython installation folder
6. Click Ok
7. A restart might be required...
  
 Or  
   
 Run the following environment variable script snippet in for example Powershell
 ```
 $pythonPath = "<Location of python folder e.g. C:\WPy-3670\python-3.6.7.amd64>"
 [Environment]::SetEnvironmentVariable("Path", "$env:Path;$pythonPath", "User")
 ```

#### Keeper Security Account
A Keeper Security account is required, "Keeper is free for local password management on your device. Premium subscriptions provides cloud-based capabilites including multi-device sync, shared folders, teams, SSO integration and encrypted file storage. [Keeper Security](https://keepersecurity.com/) Test and work has only been done on Cloud account and Enterprise account not local accounts

#### Powershell
Install [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6)

#### keepersecurity.powershell module
By downloading the module from here you'll get the module, manifest and all python scripts required for the module to work (you might want to remove the -master part of the folder once un-zipped). Move the module folder to the Powershell module folder <C:\Program Files\WindowsPowerShell\Modules\>  
  
Open a Powershell window (note: you'll get a warning message of verbs not being used correctly, you can ignore that)
 ```
 C:\PS> Import-Module keepersecurity.powershell 
 ```

#### Verify Installation
To verify that the installation of python and the configuration of the environment variables is done successfully, open the WinPython Command Prompt and type the following. 
```
$ python --version
```
if you get the python version as response you've succeded  
![alt text](https://github.com/tonylanglet/keepersecurity.powershell/blob/master/Images/pythonversion.PNG?raw=true)


To verify that the Keeper commander module has been loaded type the following in the WinPython Command Prompt:
```
$ keeper
```
if you're prompted with commands for the keeper module the installation has been successful.  
![alt text](https://github.com/tonylanglet/keepersecurity.powershell/blob/master/Images/keepercommanderoutput.png?raw=true)  
  
To verfiy that the keepersecurity.powershell module is loaded type the following in a powershell window
 ```
 C:\PS> Get-Module -Name keepersecurity.powershell
 ```
 If you get the following output the module is loaded
 ```
 ModuleType Version    Name                                ExportedCommands                                                       
 ---------- -------    ----                                ----------------                                                   
 Script     1.0        keepersecurity.powershell           {Add-KeeperRecordNotes, Del-KeeperEnterpriseTeam...} 
 ```  
### Test
The following examples show you how to run the scripts by themself or by using the Powershell module
#### Using Powershell to run scripts
```
python C:\Keper\get-keeperrecord.py --ausername <Username> --apassword <Password> --record "tKvMeXApaOEzhkCkQRtAcw" --format "json"
```
#### Using Powershell module
Make sure the keepersecurity.powershell module is loaded, see installation step above. Once the module is loaded you can use the functions.
```
'Add-KeeperRecordNotes', 
'Del-KeeperEnterpriseTeam', 
'Del-KeeperEnterpriseUser', 
'Del-KeeperFolder', 
'Del-KeeperRecord', 
'Del-KeeperRecordAttachment', 
'Get-KeeperAuditLog', 
'Get-KeeperAuditReport', 
'Get-KeeperEnterpriseInfo', 
'Get-KeeperFolder', 
'Get-KeeperRecord', 
'Get-KeeperRecordAttachment', 
'Link-KeeperFolder', 
'Link-KeeperRecord', 
'List-KeeperFolder', 
'List-KeeperRecord', 
'Move-KeeperFolder',
'New-KeeperEnterpriseTeam', 
'New-KeeperEnterpriseUser', 
'New-KeeperRecord', 
'New-KeeperRecordAttachment', 
'New-KeeperSharedFolder', 
'New-KeeperUser', 
'New-KeeperUserFolder',
'Search-KeeperRecord', 
'Set-KeeperEnterpriseRole', 
'Set-KeeperEnterpriseTeam', 
'Set-KeeperSharedFolderPermissions', 
'Set-KeeperSharedRecordPermissions',
'Push-KeeperEnterpriseDefaultRecords'
```   
   
The functions require a keeper security account, to be run the account credentials will have to be stored in a [pscredential] object and sent as input with each function. 
``` 
$authuser = "<username>"
$authpass = "<password>"

$password = $authpass | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PsCredential($authuser,$password)
``` 
Running one of the modules functions,
```
# The following module function will display a specified records information in a JSON string  

Get-KeeperRecord -Identity "<recordUid>" -Format json -AuthObject $credentials
``` 
## Setup Explanation 
I feel like explaning the setup and why it's done as it is. Keeper Security provide us with a SDK where we get to use a python based cmd prompt and a module for all commands Keeper provide us with. Keeper Security have made the decision to make the access through their own module as there's different stages of encrypting the data sent to their API.  
  
This repository is built on Python scripts which in the back end is using the Keeper Commander functionality. The python scripts can be run by any programming or scripting language which have the capability to run python.    
  
In this build we are using Powershell as a front and calling python scripts in the back with arguments for the different functionality within the Keeper Commander hence the prerequisities of python and Keeper commander.

## Built With

* [KeeperCommander](https://github.com/Keeper-Security/Commander) - The SDK used
* [WinPython](https://winpython.github.io/) - Backend scripts using
* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) - The main framework used

## Contributing

Feel free to submit a Pull request...

## Versioning

For the versions available, see the [tags on this repository](https://github.com/tonylanglet/keepersecurity.powershell/tags). 

## Authors

* **Tony Langlet** - *Initial work* - [TonyLanglet](https://github.com/tonylanglet)

See also the list of [contributors](https://github.com/tonylanglet/keepersecurity.powershell/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Would like to thank the Keeper Security (keepercommander) staff for the fast response when in need of help.
* Would like to give credits to @JimPahlAtSkyline whos been testing functionality in the Module. 

