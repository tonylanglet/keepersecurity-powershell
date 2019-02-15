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
2. From the install folder of WinPython, run the "WinPython Command Prompt"

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

#### KeeperCommander module
1. Open "WinPython Command Prompt"
2. Install Keeper commander with pip3:
```
pip3 --install keepercommander
```
#### Keeper security account
You are required a Keeper security account, there is a free product model but it only allows certain amount of entries. 

#### Powershell
Install [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6)


To verify that the installation of python and the configuration of the environment variables is done successfully, open the WinPython Command Prompt and type the following. 
```
python --version
```
if you get the python version as response you've succeded


To verify that the Keeper commander module has been loaded type the following in the WinPtyhon Command Prompt:
```
keeper
```
if you're prompted with commands for the keeper module the installation has been successful.

## Running the tests


## Built With

* [KeeperCommander](https://github.com/Keeper-Security/Commander) - The SDK used
* [WinPython](https://winpython.github.io/) - Backend scripts using
* [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) - The main framework used

## Contributing

Feel free to submit a build...

## Versioning

For the versions available, see the [tags on this repository](https://github.com/tonylanglet/keepersecurity.powershell/tags). 

## Authors

* **Tony Langlet** - *Initial work* - [TonyLanglet](https://github.com/tonylanglet)

See also the list of [contributors](https://github.com/tonylanglet/keepersecurity.powershell/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Would like to thank Keeper Security for the fast response when questions was asked and to clearify the use of a python module instead of a API.

