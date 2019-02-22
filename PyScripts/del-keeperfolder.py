import sys
import getopt
import getpass
import string
import re
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderRemoveCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# ADD NEW RECORD INTO KEEPER
def del_folder(folderUID, folderForce):
    command = FolderRemoveCommand()
    recordResult = command.execute(my_params, folder=folderUID, force=folderForce)
    print("Successfully")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Record parameters
    folderUID = None
    folderForce = True
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--folder", type=str, help="Folder UID", required=True)
    parser.add_argument("--force", type=str, help="force y/n, true/false", default=True)
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username", required=True)
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password", required=True)
    args = parser.parse_args()

    if args.folder:
        folderUID = args.folder
    if args.force:
        folderForce = args.force
    if args.ausername:
        authUsername = args.ausername
    if args.apassword:
        authPassword = args.apassword
    
    while not my_params.user:
        my_params.user = authUsername

    while not my_params.password:
        my_params.password = authPassword
    api.sync_down(my_params)

    # Start function
    result = del_folder(folderUID, folderForce)

if __name__ == "__main__":
    main(sys.argv[1:])
