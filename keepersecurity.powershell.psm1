
function New-KeeperRecord {
<#
.SYNOPSIS
  Creates a new Record
.DESCRIPTION
  This script creates a record in Keeper security
.PARAMETER Title
    Optional [string], descriptive title of the record
.PARAMETER Login
    Optional [string], the login/username 
.PARAMETER Password
    Optional [string], If sent empty a password will be generated
.PARAMETER URL
    Optional [string], Provide if necessary
.PARAMETER Notes
    Optional [string], Descriptive notes of the record
.PARAMETER CustomFields
    Optional [string], requires the following syntax "key1:value1,key2:value2"...
.PARAMETER FolderUId
    Optional [string], provide the folder UID 
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperRecord.
.OUTPUTS
  System.String New-KeeperRecord returns a string with the Record UID
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Creates a empty record
  C:\PS> New-KeeperRecord -AuthObject $credentials

.EXAMPLE 2 
  Creates a new record with the parameters for Title, Login, and Password
  C:\PS> New-KeeperRecord -Title "NewRecord" -Login "Username" -Password "Hello1234" -AuthObject $credentials

.EXAMPLE 3
  Creates a new record and generates a password in Keeper, two custom fields are created named APIKey and SecretKey and the record will be stored in the folder specified
  C:\PS> New-KeeperRecord -Title "NewRecord" -Login "Username" -CustomFields "APIKey:xyz,SecretKey:1234" -FolderUId "12jJF3j#-jsdkeCKsS" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)][string]$Title,
    [Parameter(Mandatory=$false)][string]$Login,
    [Parameter(Mandatory=$false)][string]$Password,
    [Parameter(Mandatory=$false)][string]$Url,
    [Parameter(Mandatory=$false)][string]$Notes,
    [Parameter(Mandatory=$false)][string]$Customfields,
    [Parameter(Mandatory=$false)][string]$FolderUId,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($title)) { $Parameters += "--title", $title }
if(![string]::IsNullOrEmpty($login)) { $Parameters += "--login", $login }
if(![string]::IsNullOrEmpty($password)) { $Parameters += "--password", $password }
if(![string]::IsNullOrEmpty($url)) { $Parameters += "--url", $url }
if(![string]::IsNullOrEmpty($notes)) { $Parameters += "--notes", $notes }
if(![string]::IsNullOrEmpty($customfields)) { $Parameters += "--custom", $customfields }
if(![string]::IsNullOrEmpty($folderUId)) { $Parameters += "--folder", $folderUId }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperRecord.py" @Parameters
    }
    catch
    {
        Write-Error "New-KeeperRecord: Unable to create new record"
        $result = "Error: $_"
    }
return $result

}

function Get-KeeperRecord {
<#
.SYNOPSIS
  Retreive specified record
.DESCRIPTION
  This script will output information about a specific record
.PARAMETER Identity
    * Required [string], A record UID or record name
.PARAMETER Format
    * Required [string], either a detailed description or json formated string.
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperRecord
.OUTPUTS
  A string or a JSON formated output
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Outputs a json string for the record 3Dfeca#fca3Cyv
  C:\PS> Get-KeeperRecord -Identity "3Dfeca#fca3Cyv" -Format "json" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$false)][ValidateSet("json","detail")][string]$Format,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record", $Identity }
if(![string]::IsNullOrEmpty($format)) { $Parameters += "--format", $format }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Get-KeeperRecord.py" @Parameters
    }
    catch 
    {
        Write-Error "Get-KeeperRecord: Unable to create new record"
        $result = "Error: $_"
    }
return $result
}

function Remove-KeeperRecord {
<#
.SYNOPSIS
  Removes specified record
.DESCRIPTION
  This script will remove the specified record
.PARAMETER Identity
    * Required [string], A record UID or record name
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperRecord
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  C:\PS> Del-KeeperRecord -Identity "3Dfeca#fca3Cyv" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record",$Identity }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Del-KeeperRecord.py" @Parameters
    }
    catch 
    {
        Write-Error "Del-KeeperRecord: Unable to create new record"
        $result = "Error: $_"
    }
return $result
}

function Get-KeeperRecordList {
<#
.SYNOPSIS
  List Keeper records
.DESCRIPTION
  Providing a regex pattern will display the result of records that match the regex
.PARAMETER Pattern
    * Required [string], A Regex to match records to
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to List-KeeperRecord
.OUTPUTS
  A List of records matching the provided regex pattern
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  List all records
  C:\PS> List-KeeperRecord -Pattern "^" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Pattern,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($pattern)) { $Parameters += "--pattern",$pattern }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\List-KeeperRecord.py" @Parameters
    }
    catch 
    {
        Write-Error "List-KeeperRecord: Unable to create new record"
        $result = "Error: $_"
    }
return $result
}

function Search-KeeperRecord {
<#
.SYNOPSIS
  List Keeper records
.DESCRIPTION
  Providing a regex pattern will display the result of records that match the regex
.PARAMETER Pattern
    * Required [string], A Regex to match records to
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Search-KeeperRecord
.OUTPUTS
  A List of records matching the provided regex pattern
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  List all records
  C:\PS> Search-KeeperRecord -Pattern "^" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Pattern,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($pattern)) { $Parameters += "--pattern",$pattern }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Search-KeeperRecord.py" @Parameters
    }
    catch 
    {
        Write-Error "Search-KeeperRecord: Unable to create new record"
        $result = "Error: $_"
    }
return $result
}

function Add-KeeperRecordNotes {
<#
.SYNOPSIS
  Append notes to a existing record
.DESCRIPTION
  The added note will append to the orginal notes on a new line on a existing record
.PARAMETER Identity
    * Required [string], Record UID or name
.PARAMETER Notes
    * Optional [string], Notes to append to the current notes of an existing record
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Add-KeeperRecordNotes
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  C:\PS> Add-KeeperRecordNotes -Record "_saE3cECJo4vla" -Notes "New information in notes" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$false)][string]$Notes,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record", $Identity }
if(![string]::IsNullOrEmpty($notes)) { $Parameters += "--notes", $notes }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Add-KeeperRecordNotes.py" @Parameters
    }
    catch 
    {
        Write-Error "Add-KeeperRecordNotes: Unable to create new record"
        $result = "Error: $_"
    }
return $result
}

function Get-KeeperRecordAttachment {
<#
.SYNOPSIS
  Download attachments from a record
.DESCRIPTION
  This script will download all attachments from a record and put them into a zip:ed file
.PARAMETER Identity
    * Required [string], Record UID or name
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperRecordAttachment
.OUTPUTS
  A zipped file with all attachments in it
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  C:\PS> Get-KeeperRecordAttachment -Record "_saE3cECJo4vla" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record",$Identity }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Get-KeeperRecordAttachment.py" @Parameters
    }
    catch 
    {
        Write-Error "Get-KeeperRecordAttachment: Unable to get attachment"
        $result = "Error: $_"
    }
return $result
}

function Remove-KeeperRecordAttachment {
<#
.SYNOPSIS
  Remove attachment from a record
.DESCRIPTION
  This script will remove a attachment from the record
.PARAMETER Identity
    * Required [string], Record UID or name
.PARAMETER Name
    * Required [string], The name of the attachment file
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Del-KeeperRecordAttachment
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Will remove the image named print_screen.jpg from the record
  C:\PS> Add-KeeperRecordNotes -Record "_saE3cECJo4vla" -Name "print_screen.jpg" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record", $Identity }
if(![string]::IsNullOrEmpty($Name)) { $Parameters += "--name", $Name }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Del-KeeperRecordAttachment.py" @Parameters
    }
    catch 
    {
        Write-Error "Add-KeeperRecordAttachment: Unable to delete attachment"
        $result = "Error: $_"
    }
return $result
}

function New-KeeperRecordAttachment {
<#
.SYNOPSIS
  Add attachments to a record
.DESCRIPTION
  This script will add files as attachments to a record
.PARAMETER Identity
    * Required [string], Record UID or name
.PARAMETER FilePath
    * Required [string[]], Requires a list of file(s) 
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperRecordAttachment
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  C:\PS> New-KeeperRecordAttachment -Record "_saE3cECJo4vla" -FilePath @("c:\temp\image.jpg") -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][string[]]$FilePath,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record", $Identity }
if(![string]::IsNullOrEmpty($filePath)) { $Parameters += "--file", $filePath } # Requires to be a list?
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperRecordAttachment.py" @Parameters
    }
    catch 
    {
        Write-Error "New-KeeperRecordAttachment: Unable to add attachment"
        $result = "Error: $_"
    }
return $result
}

function Set-KeeperSharedRecordPermissions {
<#
.SYNOPSIS
  Append notes to a existing record
.DESCRIPTION
  The added note will append to the orginal notes on a new line on a existing record
.PARAMETER Identity
    * Required [string], Record UID or name
.PARAMETER Mail
    Optional [string], the user account gaining permission changes
.PARAMETER Action
    Optional [string], grant/revoke/owner permissions on record for user
.PARAMETER Share
    Optional [switch], Allow the user to share the record
.PARAMETER Write
    Optional [switch], Allow the user write permissions on the record
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Set-KeeperSharedRecordPermissions
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Grant permissions on a existing shared record for the user with mail user@domain.com
  C:\PS> Set-KeeperSharedRecordPermissions -Record "_saE3cECJo4vla" -Mail "user@domain.com" -Action grant -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$false)][string]$Mail,
    [Parameter(Mandatory=$false)][ValidateSet("grant","revoke","owner")][string]$Action,
    [Parameter(Mandatory=$false)][switch]$Share,
    [Parameter(Mandatory=$false)][switch]$Write,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record", $Identity }
if(![string]::IsNullOrEmpty($mail)) { $Parameters += "--email", $mail }
if(![string]::IsNullOrEmpty($action)) { $Parameters += "--action", $action }
if($share) { $Parameters += "--share", $share }
if($write) { $Parameters += "--write", $write }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Share-KeeperRecord.py" @Parameters
    }
    catch 
    {
        Write-Error "Share-KeeperRecord: Unable to add attachment"
        $result = "Error: $_"
    }
return $result
}

function Set-KeeperRecordLink {
<#
.SYNOPSIS
  Link a record to another location
.DESCRIPTION
  This script will Link a record to a different location
.PARAMETER Identity
    * Required [string], Record UID or Name
.PARAMETER Destination
    * Required [string], Link a record to a different location "\" (root)
.PARAMETER CanShare
    Optional [switch], Allow sharing of records
.PARAMETER CanEdit
    Optional [switch], Allow editing of records
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Link-KeeperRecord
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Will add a link of the record <Record #1> in the folder named <Folder #2> in root
  C:\PS> Link-KeeperRecord -Identity "Record #1" -Destination "\Folder #2" -AuthObject $credentials

.EXAMPLE 2
  Will add a link of the record <Record #1> in the folder named <Folder #2> in root and allows content to be editited and reshared
  C:\PS> Link-KeeperRecord -Identity "Record #1" -Destination "\Folder #2" -CanEdit -CanReshare -AuthObject $credentials


#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][string]$Destination,
    [Parameter(Mandatory=$false)][switch]$CanEdit,
    [Parameter(Mandatory=$false)][switch]$CanReShare,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--source",$Identity }
if(![string]::IsNullOrEmpty($Destination)) { $Parameters += "--destination",$Destination }
if($canEdit) { $Parameters += "--can-edit",$canEdit }
if($canReShare) { $Parameters += "--can-reshare",$canReShare }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Link-KeeperRecord.py" @Parameters
    }
    catch 
    {
        Write-Error "Link-KeeperRecord: Unable to link record"
        $result = "Error: $_"
    }
return $result
}

# FOLDER
function Get-KeeperFolder {
<#
.SYNOPSIS
  Retreive information of a specified folder
.DESCRIPTION
  This script will output information about a specific folder
.PARAMETER Identity
    * Required [string], A folder UID
.PARAMETER Format
    * Required [string], either a detailed description or json formated string.
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperFolder
.OUTPUTS
  A string or a JSON formated output
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Outputs a json string for the record 3Dfeca#fca3Cyv
  C:\PS> Get-KeeperRecord -Identity "3Dfeca#fca3Cyv" -Format "json" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$false)][ValidateSet("json","detail")][string]$Format,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--folder", $Identity }
if(![string]::IsNullOrEmpty($format)) { $Parameters += "--format", $format }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Get-KeeperFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "Get-KeeperRecord: Unable to retreive folder info"
        $result = "Error: $_"
    }
return $result
}

function Get-KeeperFolderList {
<#
.SYNOPSIS
  List folders
.DESCRIPTION
  List the folders located in the current users context
.PARAMETER List
    Optional [switch], List all content
.PARAMETER Folders
    Optional [switch], List folders
.PARAMETER Records
    Optional [switch], List records
.PARAMETER Pattern
    Optional [switch], Regex pattern to match
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to List-KeeperFolder
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Show a full list of objects
  C:\PS> List-KeeperFolder -List -AuthObject $credentials
  
.EXAMPLE 2
  Show a full list of folders
  C:\PS> List-KeeperFolder -List -Folders -AuthObject $credentials
  
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)][switch]$List,
    [Parameter(Mandatory=$false)][switch]$Folders,
    [Parameter(Mandatory=$false)][switch]$Records,
    [Parameter(Mandatory=$false)][string]$Pattern,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if($list) { $Parameters += "--list",$list }
if($folders) { $Parameters += "--folders", $folders }
if($records) { $Parameters += "--records", $records }
if(![string]::IsNullOrEmpty($pattern)) { $Parameters += "--pattern", $pattern }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\List-KeeperFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "List-KeeperFolder: Unable to add attachment"
        $result = "Error: $_"
    }
return $result
}

function Remove-KeeperFolder {
<#
.SYNOPSIS
  Remove a folder
.DESCRIPTION
  Remove a folder and its content
.PARAMETER Identity
    * Required [string], Folder UID or name
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Del-KeeperFolder
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Removes the folder with the name Folder #1 in root
  C:\PS> Del-KeeperFolder -Identity "Folder #1" -AuthObject $credentials

.EXAMPLE 2
  Removes the folder with the UID 1CdbvrWQ3F%HG-
  C:\PS> Del-KeeperFolder -Identity "1CdbvrWQ3F%HG-" -AuthObject $credentials
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @{}
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--folder", $Identity }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Del-KeeperFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "Del-KeeperFolder: Unable to remove folder"
        $result = "Error: $_"
    }
return $result
}

function New-KeeperUserFolder {
<#
.SYNOPSIS
  Creates a personal folder
.DESCRIPTION
  This script creates a personal folder for the current user
.PARAMETER Name
    * Required [string], Folder name
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperUserFolder
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Creates a folder with the name Folder #1 in root
  C:\PS> New-KeeperUserFolder -Name "Folder #1" -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Name, 
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($name)) { $Parameters += "--name", $name }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperUserFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "New-KeeperUserFolder: Unable to create a new user folder"
        $result = "Error: $_"
    }
return $result
}

function New-KeeperSharedFolder {
<#
.SYNOPSIS
  Creates a shared folder
.DESCRIPTION
  This script creates a shared folder
.PARAMETER Name
    * Required [string], Folder name
.PARAMETER Permission
    Optional [switch], Allow permission for all 
.PARAMETER ManageUsers
    Optional [switch], Allow management of users
.PARAMETER ManageRecords
    Optional [switch], Allow management of records
.PARAMETER CanShare
    Optional [switch], Allow sharing of records and folders
.PARAMETER CanEdit
    Optional [switch], All editing of records and folders
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperSharedFolder
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Creates a shared folder with the name Folder #1 in root
  C:\PS> New-KeeperSharedFolder -Name "Folder #1" -AuthObject $credentials

.EXAMPLE 2
  Creates a shared folder with the name Folder #2 in root, and assign permissions to all and disallow sharing of records and folders
  C:\PS> New-KeeperSharedFolder -Name "Folder #2" -Permission -CanShare -CanEdit -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$false)][switch]$Permission,
    [Parameter(Mandatory=$false)][switch]$ManageUsers,
    [Parameter(Mandatory=$false)][switch]$ManageRecords,
    [Parameter(Mandatory=$false)][switch]$CanShare,
    [Parameter(Mandatory=$false)][switch]$CanEdit,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Name)) { $Parameters += "--name", $Name }
if($permission) { $Parameters += "--all", $permission }
if($manageUsers) { $Parameters += "--manage-users", $manageUsers }
if($manageRecords) { $Parameters += "--manage-records", $manageRecords }
if($canShare) { $Parameters += "--can-share", $canShare }
if($canEdit) { $Parameters += "--can-edit", $canEdit }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperSharedFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "New-KeeperSharedFolder: Unable to create a new shared folder"
        $result = "Error: $_"
    }
return $result
}

function Move-KeeperFolder {
<#
.SYNOPSIS
  Move a current shared folder
.DESCRIPTION
  This script will move a shared folder to a new location
.PARAMETER Identity
    * Required [string], Folder UID or Name
.PARAMETER Destination
    * Required [string], Where to move the folder to "\<folder name>" or Folder UID 
.PARAMETER CanShare
    Optional [switch], Allow sharing of records and folders
.PARAMETER CanEdit
    Optional [switch], All editing of records and folders
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Move-KeeperFolder
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Will move the folder named <Folder #1> to the folder named <Folder #2> in root
  C:\PS> Move-KeeperFolder -Identity "Folder #1" -Destination "\Folder #2" -AuthObject $credentials

.EXAMPLE 2
  will move the folder named <Folder #1> to the folder with UID <dfRE4V#2ckq-p> and disallow sharing of records and folders
  C:\PS> Move-KeeperFolder -Identity "Folder #2" -Destination "dfRE4V#2ckq-p" -CanShare -CanEdit -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][string]$Destination,
    [Parameter(Mandatory=$false)][switch]$CanEdit,
    [Parameter(Mandatory=$false)][switch]$CanReShare,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--source",$Identity }
if(![string]::IsNullOrEmpty($destination)) { $Parameters += "--destination",$destination }
if($canEdit) { $Parameters += "--can-edit",$canEdit }
if($canReShare) { $Parameters += "--can-reshare",$canReShare }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Move-KeeperFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "Move-KeeperFolder: Unable to move folder"
        $result = "Error: $_"
    }
return $result
}

function Set-KeeperFolderLink {
<#
.SYNOPSIS
  Link a folder to another location
.DESCRIPTION
  This script will Link a folder to a different location
.PARAMETER Identity
    * Required [string], Folder UID or Name
.PARAMETER Destination
    * Required [string], Link a folder to a different location "\" (root)
.PARAMETER CanShare
    Optional [switch], Allow sharing of folder
.PARAMETER CanEdit
    Optional [switch], Allow editing of folder
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Link-KeeperFolder
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Will add a link of the folder <Folder #1> in the in root
  C:\PS> Link-KeeperRecord -Identity "Folder #1" -Destination "\" -AuthObject $credentials

.EXAMPLE 2
  Will add a link of the folder <Folder #2> in the folder named <SubFolder> in root
  C:\PS> Link-KeeperRecord -Identity "Folder #2" -Destination "\SubFolder" -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][string]$Destination,
    [Parameter(Mandatory=$false)][switch]$CanEdit,
    [Parameter(Mandatory=$false)][switch]$CanReShare,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--source",$Identity }
if(![string]::IsNullOrEmpty($Destination)) { $Parameters += "--destination",$Destination }
if($canEdit) { $Parameters += "--can-edit",$CanEdit }
if($canReShare) { $Parameters += "--can-reshare",$CanReShare }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Link-KeeperFolder.py" @Parameters
    }
    catch 
    {
        Write-Error "Link-KeeperFolder: Unable to link folder"
        $result = "Error: $_"
    }
return $result
}

function Set-KeeperSharedFolderPermissions {
<#
.SYNOPSIS
  Assign permissions on a shared folder
.DESCRIPTION
  This script will change the current permission level on a shared folder
.PARAMETER Identity
    * Required [string], Folder UID or Name
.PARAMETER Action
    Optional [string], grant/revoke/owner assing the permission level to the user
.PARAMETER User
    Optional [string], A user or team that will be affected by the permission change
.PARAMETER ManageRecords
    Optional [switch], Allow managing of records
.PARAMETER ManageUsers
    Optional [switch], Allow managing of users allowed to access the folder
.PARAMETER CanShare
    Optional [switch], Allow sharing of folders and records
.PARAMETER CanEdit
    Optional [switch], Allow editing of folders and records
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Set-KeeperSharedFolderPermissions
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Disallow everyone from editing any folders or records in the shared folder named <Folder #1>
  C:\PS> Set-KeeperSharedFolderPermissions -Identity "Folder #1" -CanEdit -AuthObject $credentials

.EXAMPLE 2
  Grant access for user user@domain.com to the folder named <Folder #1> 
  C:\PS> Set-KeeperSharedFolderPermissions -Identity "Folder #1" -Action grant -User "user@domain.com" -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$false)][string]$Action,
    [Parameter(Mandatory=$false)][string]$User,
    [Parameter(Mandatory=$false)][string]$Record,
    [Parameter(Mandatory=$false)][switch]$ManageRecords,
    [Parameter(Mandatory=$false)][switch]$ManageUsers,
    [Parameter(Mandatory=$false)][switch]$CanShare,
    [Parameter(Mandatory=$false)][switch]$CanEdit,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--folder",$Identity }
if(![string]::IsNullOrEmpty($action)) { $Parameters += "--action",$action }
if(![string]::IsNullOrEmpty($user)) { $Parameters += "--user",$user }
if(![string]::IsNullOrEmpty($record)) { $Parameters += "--record",$record }
if($manageRecords) { $Parameters += "--manage-records",$manageRecords }
if($manageUsers) { $Parameters += "--manage-users",$manageUsers }
if($canShare) { $Parameters += "--can-share",$canShare }
if($canEdit) { $Parameters += "--can-edit",$canEdit }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Set-KeeperSharedFolderPermission.py" @Parameters
    }
    catch 
    {
        Write-Error "Share-KeeperFolder: Unable to link folder"
        $result = "Error: $_"
    }
return $result
}

# USER
function New-KeeperUser {
<#
.SYNOPSIS
  Create a new local user in Keeper
.DESCRIPTION
  This script will create a local user in Keeper
.PARAMETER Email
    * Required [string], Email address where the invite will be sent and used as username in some cases
.PARAMETER Password
    Optional [string], Password for the account, if left empty a password will be generated
.PARAMETER Name
    Optional [string], Name for the user account, does not work with enterprise license
.PARAMETER DataCenter
    Optional [string], The Data center where the user object will be created in (eu/us)
.PARAMETER Node
    Optional [string], The node where the user object will be created in
.PARAMETER SecretQuestion
    * REquired [string], Secret question that will require a answer during password reset 
.PARAMETER SecretAnswer
    * Required [string], Secret answer which will be asked for during password reset
.PARAMETER StoreRecord
    Optional [string], ???
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperUser
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Create a local user account named Jon Doe
  C:\PS> New-KeeperUser -Email "jon.doe@domain.com" -Name "Jon Doe" -Password "Hello1234" -SecretQuestion "What is Keeper" -SecretAnswer "Great" -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Mail,
    [Parameter(Mandatory=$false)][string]$Password,
    [Parameter(Mandatory=$false)][string]$Name,
    [Parameter(Mandatory=$false)][string]$DataCenter,
    [Parameter(Mandatory=$false)][string]$Node,
    [Parameter(Mandatory=$true)][string]$SecretQuestion,
    [Parameter(Mandatory=$true)][string]$SecretAnswer,
    [Parameter(Mandatory=$false)][string]$StoreRecord,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject  
)

$Parameters = @()
if(![string]::IsNullOrEmpty($mail)) { $Parameters += "--email",$mail }
if(![string]::IsNullOrEmpty($password)) { $Parameters += "--password",$password }
if(![string]::IsNullOrEmpty($name)) { $Parameters += "--name",$name }
if(![string]::IsNullOrEmpty($DataCenter)) { $Parameters += "--data-center",$DataCenter }
if(![string]::IsNullOrEmpty($node)) { $Parameters += "--node", $node }
if(![string]::IsNullOrEmpty($secretQuestion)) { $Parameters += "--question",$secretQuestion }
if(![string]::IsNullOrEmpty($secretAnswer)) { $Parameters += "--answer",$secretAnswer }
if(![string]::IsNullOrEmpty($storeRecord)) { $Parameters += "--store-record",$storeRecord }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperUser.py" @Parameters
    }
    catch 
    {
        Write-Error "New-KeeperUser: Unable to create new keeper user"
        $result = "Error: $_"
    }
return $result
}

# ENTERPRISE INFO
function Get-KeeperEnterpriseInfo {
<#
.SYNOPSIS
  Retreive information about the enterprise setup
.DESCRIPTION
  A customized or detailed view of the enterprise setup
.PARAMETER Nodes
    Optional [switch], List the nodes in the enterprise
.PARAMETER Users
    Optional [switch], List the users in the enterprise
.PARAMETER Teams
    Optional [switch], List the teams in the enterprise
.PARAMETER Roles
    Optional [switch], List the roles in the enterprise
.PARAMETER Node
    Optional [string], A list of users/teams/roles in certain node
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperEnterpriseInfo
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Full list of enterprise information
  C:\PS> Get-KeeperEnterpriseInfo -AuthObject $credentials

.EXAMPLE 2
  Full list of users in the enterprise
  C:\PS> Get-KeeperEnterpriseInfo -Users -AuthObject $credentials

.EXAMPLE 3
  List of teams located in the Node named <Contoso>
  C:\PS> Get-KeeperEnterpriseInfo -Teams -Node "CONTOSO" -AuthObject $credentials

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)][switch]$Nodes,
    [Parameter(Mandatory=$false)][switch]$Users,
    [Parameter(Mandatory=$false)][switch]$Teams,
    [Parameter(Mandatory=$false)][switch]$Roles,
    [Parameter(Mandatory=$false)][string]$Node,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if($nodes) { $Parameters += "--nodes",$nodes }
if($users) { $Parameters += "--users",$users }
if($teams) { $Parameters += "--teams",$teams }
if($roles) { $Parameters += "--roles",$roles }
if(![string]::IsNullOrEmpty($node)) { $Parameters += "--node",$node }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Get-KeeperEnterpriseInfo.py" @Parameters
    }
    catch 
    {
        Write-Error "Get-KeeperEnterpriseInfo: Unable to link folder"
        $result = "Error: $_"
    }
return $result
}

# ENTERPRISE USER
function Set-KeeperEnterpriseUser {
<#
.SYNOPSIS
  Edit a enterprise user
.DESCRIPTION
  This scripts gives the opportunity to edit a enterprise user object and add different
  functionality to the user account such ass role and team membership
.PARAMETER Identity
    Optional [string], The user identity (email)
.PARAMETER ExpireMasterPassword
    Optional [switch], Expire the master password 
.PARAMETER Lock
    Optional [switch], Lock the user account
.PARAMETER Unlock
    Optional [switch], Unlock the user account
.PARAMETER Name
    Optional [string], Change the name of a user account
.PARAMETER Node
    Optional [string], Specify the node the user account is located in
.PARAMETER RoleToAdd
    Optional [string], Add a role to the user account
.PARAMETER RoleToRemove
    Optional [string], Remove a role to the user account
.PARAMETER TeamToAdd
    Optional [string], Add the user to a team
.PARAMETER TeamToRemove
    Optional [string], Remove the user from a team
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Set-KeeperEnterpriseUser
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Lock a user account with the email address <jon.doe@domain.com>
  C:\PS> Set-KeeperEnterpriseUser -Identity "jon.doe@domain.com" -Lock True -AuthObject $credentials

.EXAMPLE 2
  Unlock a user account with the email address <jon.doe@domain.com> and assign the account the <Administrator> role
  C:\PS> Set-KeeperEnterpriseUser -Identity "jon.doe@domain.com" -Unlock True -RoleToAdd "Administrator" -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)][string]$Identity, #mail
    [Parameter(Mandatory=$false)][switch]$ExpireMasterPassword,
    [Parameter(Mandatory=$false)][switch]$Lock,
    [Parameter(Mandatory=$false)][switch]$Unlock,
    [Parameter(Mandatory=$false)][string]$Name,
    [Parameter(Mandatory=$false)][string]$Node,
    [Parameter(Mandatory=$false)][string]$RoleToAdd,
    [Parameter(Mandatory=$false)][string]$RoleToRemove,
    [Parameter(Mandatory=$false)][string]$TeamToAdd,
    [Parameter(Mandatory=$false)][string]$TeamToRemove,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--email",$Identity }
if($ExpireMasterPassword) { $Parameters += "--expire",$ExpireMasterPassword }
if(![string]::IsNullOrEmpty($Name)) { $Parameters += "--name",$Name }
if(![string]::IsNullOrEmpty($Node)) { $Parameters += "--node",$Node }
if(![string]::IsNullOrEmpty($RoleToAdd)) { $Parameters += "--add-role",$RoleToAdd }
if(![string]::IsNullOrEmpty($RoleToRemove)) { $Parameters += "--remove-role",$RoleToRemove }
if(![string]::IsNullOrEmpty($TeamToAdd)) { $Parameters += "--add-team",$TeamToAdd }
if(![string]::IsNullOrEmpty($TeamToRemove)) { $Parameters += "--remove-team",$TeamToRemove }
if($Unlock) { $Parameters += "--unlock",$Unlock }
if($Lock) { $Parameters += "--lock",$Lock }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Set-KeeperEnterpriseUser.py" @Parameters
    }
    catch 
    {
        Write-Error "Set-KeeperEnterpriseUser: Unable to set enterprise user"
        $result = "Error: $_"
    }
return $result
}

function New-KeeperEnterpriseUser {
<#
.SYNOPSIS
  Edit a enterprise user
.DESCRIPTION
  This scripts gives the opportunity to edit a enterprise user object and add different
  functionality to the user account such ass role and team membership
.PARAMETER Mail
    * Required [string], the user identity (email)
.PARAMETER Name
    Optional [string], name of the user account 
.PARAMETER RoleToAdd
    Optional [string], assign a role to the user account
.PARAMETER TeamToAdd
    Optional [string], assign team membership to the user account
.PARAMETER Node
    Optional [string], which node the account should be created in
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperEnterpriseUser
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Create a user account with the email address <jon.doe@domain.com>
  C:\PS> New-KeeperEnterpriseUser -Mail "jon.doe@domain.com" -AuthObject $credentials

.EXAMPLE 2
  Create a user account with the email address <jon.doe@domain.com> and assign the role <Administrator> to the account
  C:\PS> New-KeeperEnterpriseUser -Mail "jon.doe@domain.com" -RoleToAdd "Administrator" -AuthObject $credentials

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Mail,
    [Parameter(Mandatory=$false)][string]$Name,
    [Parameter(Mandatory=$false)][string]$RoleToAdd,
    [Parameter(Mandatory=$false)][string]$TeamToAdd,
    [Parameter(Mandatory=$false)][string]$Node,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Mail)) { $Parameters += "--email",$Mail }
if(![string]::IsNullOrEmpty($Name)) { $Parameters += "--name",$Name }
if(![string]::IsNullOrEmpty($RoleToAdd)) { $Parameters += "--add-role",$RoleToAdd }
if(![string]::IsNullOrEmpty($TeamToAdd)) { $Parameters += "--add-team",$TeamToAdd }
if(![string]::IsNullOrEmpty($Node)) { $Parameters += "--node",$Node }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperEnterpriseUser.py" @Parameters
    }
    catch 
    {
        Write-Error "New-KeeperEnterpriseUser: Unable to create new enterprise user"
        $result = "Error: $_"
    }
return $result
}

function Remove-KeeperEnterpriseUser {
<#
.SYNOPSIS
  Delete enterprise user
.DESCRIPTION
  This script will delete a enterprise user
.PARAMETER Identity
    * Required [string], the user identity (email)
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Del-KeeperEnterpriseUser
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Delete a user account with the email address <jon.doe@domain.com>
  C:\PS> Del-KeeperEnterpriseUser -Identity "jon.doe@domain.com" -AuthObject $credentials
  
#>
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--email", $Identity }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Del-KeeperEnterpriseUser.py" @Parameters
    }
    catch 
    {
        Write-Error "Del-KeeperEnterpriseUser: Unable to remove enterprise user"
        $result = "Error: $_"
    }
return $result
}

# ENTERPRISE ROLE
function Set-KeeperEnterpriseRole {
<#
.SYNOPSIS
  Edit enterprise role
.DESCRIPTION
  This script will edit a enterprise role
.PARAMETER Identity
    * Required [string], the role identity/name
.PARAMETER AddUser
    * Optional [string], Add a user to the role (mail)
.PARAMETER RemoveUser
    * Optional [string], Remove a user from the role (mail)
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Set-KeeperEnterpriseRole
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Add user <jon.doe@domain.com> to the role <Administrator>
  C:\PS> Set-KeeperEnterpriseRole -Identity "Administrator" -AddUser "jon.doe@domain.com" -AuthObject $credentials
  
#>
Param(
    [Parameter(Mandatory=$false)][string]$AddUser,
    [Parameter(Mandatory=$false)][string]$RemoveUser,
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($addUser)) { $Parameters += "--add-user",$addUser }
if(![string]::IsNullOrEmpty($removeUser)) { $Parameters += "--remove-user",$removeUser }
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--role",$Identity }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Set-KeeperEnterpriseRole.py" @Parameters
    }
    catch 
    {
        Write-Error "Set-KeeperEnterpriseRole: Unable to set enterprise role"
        $result = "Error: $_"
    }
return $result
}

# ENTERPRISE TEAM
function New-KeeperEnterpriseTeam {
<#
.SYNOPSIS
  Create a new enterprise team
.DESCRIPTION
  This script creates a new enterprise team
.PARAMETER Name
    * Required [string], the role identity/name
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to New-KeeperEnterpriseTeam
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Creates a new enterprise team with the name <Gold Team>
  C:\PS> New-KeeperEnterpriseTeam -Name "Gold Team" -AuthObject $credentials
  
#>
Param(
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($name)) { $Parameters += "--name", $Name }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\New-KeeperEnterpriseTeam.py" @Parameters
    }
    catch 
    {
        Write-Error "New-KeeperEnterpriseTeam: Unable create new enterprise team"
        $result = "Error: $_"
    }
return $result
}

function Set-KeeperEnterpriseTeam {
<#
.SYNOPSIS
  Edit an enterprise team
.DESCRIPTION
  This script will edit an enterprise team
.PARAMETER Identity
    * Required [string], the team identity/name
.PARAMETER AddUser
    Optional [string], add a user to the team (mail)
.PARAMETER RemoveUser
    Optional [string], remove a user from the team (mail)
.PARAMETER RestrictEdit
    Optional [string], restrict the team from editing records/folders
.PARAMETER RestrictShare
    Optional [string], restrict the team from sharing records/folders
.PARAMETER RestrictView
    Optional [string], restrict the team from viewing records/folders
.PARAMETER Node
    Optional [string], the specific node the team is located in
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Set-KeeperEnterpriseTeam
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 1
  Will add a user named <jon.doe@domain.com> to the team with the name <Gold Team>
  C:\PS> Set-KeeperEnterpriseTeam -Identity "Gold Team" -AddUser "jon.doe@domain.com -AuthObject $credentials
  
.EXAMPLE 2
  Will restrict users in the team <Gold Team> to edit folder and records
  C:\PS> Set-KeeperEnterpriseTeam -Identity "Gold Team" -RestrictEdit On -AuthObject $credentials
  
#>
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$false)][string]$AddUser,
    [Parameter(Mandatory=$false)][string]$RemoveUser,
    [Parameter(Mandatory=$false)][ValidateSet("On","Off")][string]$RestrictEdit, 
    [Parameter(Mandatory=$false)][ValidateSet("On","Off")][string]$RestrictShare, 
    [Parameter(Mandatory=$false)][ValidateSet("On","Off")][string]$RestrictView,
    [Parameter(Mandatory=$false)][string]$Node,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--team",$Identity }
if(![string]::IsNullOrEmpty($addUser)) { $Parameters += "--add-user",$addUser }
if(![string]::IsNullOrEmpty($removeUser)) { $Parameters += "--remove-user",$removeUser }
if(![string]::IsNullOrEmpty($restrictEdit)) { $Parameters += "--restrict-edit",$restrictEdit }
if(![string]::IsNullOrEmpty($restrictShare)) { $Parameters += "--restrict-share",$restrictShare }
if(![string]::IsNullOrEmpty($restrictView)) { $Parameters += "--restrict-view",$restrictView }
if(![string]::IsNullOrEmpty($node)) { $Parameters += "--node",$node }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Set-KeeperEnterpriseTeam.py" @Parameters
    }
    catch 
    {
        Write-Error "Set-KeeperEnterpriseTeam: Unable to set enterprise team"
        $result = "Error: $_"
    }
return $result
}

function Remove-KeeperEnterpriseTeam {
<#
.SYNOPSIS
  Delete an enterprise team
.DESCRIPTION
  This script will delete an enterprise team
.PARAMETER Identity
    * Required [string], the team identity/name
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Del-KeeperEnterpriseTeam
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE
  Will delete the team named <Gold Team>
  C:\PS> Del-KeeperEnterpriseTeam -Identity "Gold Team" -AuthObject $credentials
  
#>
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--team", $Identity }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Del-KeeperEnterpriseTeam.py" @Parameters
    }
    catch 
    {
        Write-Error "Del-KeeperEnterpriseTeam: Unable to delete enterprise team"
        $result = "Error: $_"
    }
return $result
}

# AUDIT LOG\REPORT
function Get-KeeperAuditLog {
<#
.SYNOPSIS
  Edit an enterprise team
.DESCRIPTION
  This script will edit an enterprise team
.PARAMETER Identity
    * Required [string], record UID or name
.PARAMETER Target
    Optional [string], splunk/syslog/sumo
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperAuditLog -AuthObject $credentials
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 
  Featch the audit log as a syslog for the record with UID <4Vr6hbddJ&bs_E8>
  C:\PS> Get-KeeperAuditLog -Identity "4Vr6hbddJ&bs_E8" -Target Syslog
   
#>
Param(
    [Parameter(Mandatory=$true)][string]$Identity,
    [Parameter(Mandatory=$true)][ValidateSet("splunk","syslog","sumo")][string]$Target,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($Identity)) { $Parameters += "--record", $Identity }
if(![string]::IsNullOrEmpty($target)) { $Parameters += "--target", $target }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Get-KeeperAuditLog.py" @Parameters
    }
    catch 
    {
        Write-Error "Get-KeeperAuditLog: Unable to get audit log"
        $result = "Error: $_"
    }
return $result
}

function Get-KeeperAuditReport {
<#
.SYNOPSIS
  Edit an enterprise team
.DESCRIPTION
  This script will edit an enterprise team
.PARAMETER ReportType
    Optional [string], raw/dim/hour/day/week/month/span, the report scope
.PARAMETER ReportFormat
    Optional [string], Message/Fields
.PARAMETER Columns
    Optional [string], which columns to display
.PARAMETER Aggregate
    Optional [string], occurrences/first_created/last_created
.PARAMETER Timezone
    Optional [string], timezone id
.PARAMETER Limit
    Optional [string], limit
.PARAMETER Order
    Optional [string], order descendant or ascending
.PARAMETER Created
    Optional [string], created date
.PARAMETER EventType
    Optional [string], event type
.PARAMETER Username
    Optional [string], which username
.PARAMETER ToUsername
    Optional [string], which to username
.PARAMETER RecordUid
    Optional [string], record uid
.PARAMETER SharedFolderUid
    Optional [string], shared folder uid
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Get-KeeperAuditReport
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 
  Create a report with the scope of month and a limit of 10 and order descendant
  C:\PS> Get-KeeperAuditReport -ReportType month -Limit 10 -Order desc -AuthObject $credentials
   
#>
Param(
    [Parameter(Mandatory=$false)][ValidateSet('raw', 'dim', 'hour', 'day', 'week', 'month', 'span')][string]$ReportType, 
    [Parameter(Mandatory=$false)][ValidateSet("Message","Fields")][string]$ReportFormat,
    [Parameter(Mandatory=$false)][string]$Columns,
    [Parameter(Mandatory=$false)][ValidateSet("occurrences", "first_created", "last_created")][string]$Aggregate, 
    [Parameter(Mandatory=$false)][string]$Timezone,
    [Parameter(Mandatory=$false)][string]$Limit,
    [Parameter(Mandatory=$false)][ValidateSet("desc","asc")][string]$Order,
    [Parameter(Mandatory=$false)][string]$Created,
    [Parameter(Mandatory=$false)][string]$EventType,
    [Parameter(Mandatory=$false)][string]$Username,
    [Parameter(Mandatory=$false)][string]$ToUsername,
    [Parameter(Mandatory=$false)][string]$RecordUid,
    [Parameter(Mandatory=$false)][string]$SharedFolderUid,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($ReportType)) { $Parameters += "--report-type", $ReportType }
if(![string]::IsNullOrEmpty($ReportFormat)) { $Parameters += "--report-format", $ReportFormat }
if(![string]::IsNullOrEmpty($Columns)) { $Parameters += "--columns", $Columns }
if(![string]::IsNullOrEmpty($Aggregate)) { $Parameters += "--aggregate", $Aggregate }
if(![string]::IsNullOrEmpty($Timezone)) { $Parameters += "--timezone", $Timezone }
if(![string]::IsNullOrEmpty($Limit)) { $Parameters += "--limit", $Limit }
if(![string]::IsNullOrEmpty($Order)) { $Parameters += "--order", $Order }
if(![string]::IsNullOrEmpty($Created)) { $Parameters += "--created", $Created }
if(![string]::IsNullOrEmpty($EventType)) { $Parameters += "--event-type", $EventType }
if(![string]::IsNullOrEmpty($Username)) { $Parameters += "--username", $Username }
if(![string]::IsNullOrEmpty($ToUsername)) { $Parameters += "--to-username", $ToUsername }
if(![string]::IsNullOrEmpty($RecordUid)) { $Parameters += "--record-uid", $RecordUid }
if(![string]::IsNullOrEmpty($SharedFolderUid)) { $Parameters += "--shared-folder-uid", $SharedFolderUid }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Get-KeeperAuditReport.py" @Parameters
    }
    catch 
    {
        Write-Error "Get-KeeperAuditReport: Unable to get audit report"
        $result = "Error: $_"
    }
return $result
}

function Push-KeeperEnterpriseDefaultRecords {
<#
.SYNOPSIS
  Push default template of records to team or user
.DESCRIPTION
  This script will push a template of records onto a certain team or user
.PARAMETER File
    Required [string], file name in JSON format that contains template records
.PARAMETER User
    Optional [string], User email or User ID. Records will be assigned to the user
.PARAMETER Team
    Optional [string], Team name or team UID. Records will be assigned to all users in the team
.PARAMETER AuthObject
    * Required [pscredential], need to be an account in Keeper Security
.INPUTS
  None, You cannot pipe objects to Push-KeeperEnterprise
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Tony Langlet
  Creation Date:  2019-02-28
  Purpose/Change: Initial script development
  
.EXAMPLE 
  Push access to records in the $JsonObject to the team named Golder Team 
  C:\PS> Push-KeeperEnterprise -File $JsonObject -Team "Golden Team" -AuthObject $credentials
   
#>
Param(
    [Parameter(Mandatory=$false)][string]$File, 
    [Parameter(Mandatory=$false)][string]$User,
    [Parameter(Mandatory=$false)][string]$Team,
    [Parameter(Mandatory=$true)][PSCredential]$AuthObject
)

$Parameters = @()
if(![string]::IsNullOrEmpty($ReportType)) { $Parameters += "--file", $File }
if(![string]::IsNullOrEmpty($ReportFormat)) { $Parameters += "--user", $User }
if(![string]::IsNullOrEmpty($Columns)) { $Parameters += "--team", $Team }
$Parameters += "--ausername", $AuthObject.UserName, "--apassword", ($AuthObject.GetNetworkCredential().Password)

    try 
    {
        $result = python "$PSScriptRoot\PyScripts\Push-KeeperEnterprise.py" @Parameters
    }
    catch 
    {
        Write-Error "Push-KeeperEnterprise: Unable to Push settings"
        $result = "Error: $_"
    }
return $result
}
