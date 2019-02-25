import sys
import getopt
import getpass
import string
import random
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderListCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# KEEPER COMMAND
def list_folder(folderList, folderFolder, folderRecord, folderPattern):
    command = FolderListCommand()
    recordResult = command.execute(my_params, list=folderList, folder=folderFolder, record=folderRecord, pattern=folderPattern)
    print("Success")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Variables
    folderList = None
    folderFolder = None
    folderRecord = None
    folderPattern = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', '--list', type=str, help='show detailed list')
    parser.add_argument('-f', '--folder', type=str, help='display folders')
    parser.add_argument('-r', '--record', type=str, help='display records')
    parser.add_argument('-p', '--pattern', type=str, help='search pattern')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    if args.list:
        folderList = args.list
    if args.folder:
        folderFolder = args.folder
    if args.record:
        folderRecord = args.record
    if args.pattern:
        folderPattern = args.pattern
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
    result = list_folder(folderList, folderFolder, folderRecord, folderPattern)

if __name__ == "__main__":
    main(sys.argv[1:])
