# Keeper Security with Powershell
Being able to use the Keeper security SDK with Powershell. The SDK is reliant on python and by calling python scripts in Powershell we'll be able to achieve the same result as the Keeper security cmd promt (KeeperCommander).

## Getting Started

### Prerequisites
* WinPython
* Environment variables
* KeeperCommander module for python
* Keeper security account

### Installing

#### WinPython
1. Download and install [WinPython](https://winpython.github.io/)

#### KeeperCommander module
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
 $pythonPath = "<Location of python folder e.g. c:\program files\python\>"
 [Environment]::SetEnvironmentVariable("Path", "$env:Path;$pythonPath", "User")
 ```

#### Keeper security account
A Keeper Security account is required, "Keeper is free for local password management on your device. Premium subscriptions provides cloud-based capabilites including multi-device sync, shared folders, teams, SSO integration and encrypted file storage. [Keeper Security](https://keepersecurity.com/)

#### Powershell
Install [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6)

#### Verify installation
To verify that the installation of python and the configuration of the environment variables is done successfully, open the WinPython Command Prompt and type the following. 
```
$ python --version
```
if you get the python version as response you've succeded


To verify that the Keeper commander module has been loaded type the following in the WinPython Command Prompt:
```
$ keeper
```
if you're prompted with commands for the keeper module the installation has been successful.

## Setup explenation 
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

* Would like to thank Keeper Security for the fast response when questions was asked and to clearify the use of a python module instead of a API.

