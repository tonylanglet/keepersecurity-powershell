import sys
import getopt
import getpass
import string
import random
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderMoveCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# KEEPER COMMAND
def move_folder(folderSource, folderDestination, folderCanReshare, folderCanEdit, folderForce):
    command = FolderMoveCommand()
    recordResult = command.execute(my_params, src=folderSource, dst=folderDestination, can-reshare=folderCanReshare, can-edit=folderCanEdit, force=folderForce)
    print("Success")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Variables
    folderDestination = None
    folderSource = None
    folderCanReshare = None
    folderCanEdit = None
    folderForce = True
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-src', '--source', type=str, help='sourch path to folder&record or UID')
    parser.add_argument('-dst', '--destination', type=str, help='destination folder or UID')
    parser.add_argument('-s', '--can-reshare', type=str, help='anyone can reshare records')
    parser.add_argument('-e', '--can-edit', type=str, help='anyone can edit records')
    parser.add_argument('-f', '--force', type=str, help='do not prompt', default=True)
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    if args.source:
        folderSource = args.source
    if args.destination:
        folderDestination = args.destination
    if args.can-reshare:
        folderCanReshare = args.can-reshare
    if args.can-edit:
        folderCanEdit = args.can-edit
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
    result = move_folder(folderSource, folderDestination, folderCanReshare, folderCanEdit, folderForce)

if __name__ == "__main__":
    main(sys.argv[1:])
