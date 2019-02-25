import sys
import getopt
import getpass
import string
import random
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderLinkCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()
      
# MAIN FUNCTION
def main(argv):
    # Variables
    recordDestination = None
    recordSource = None
    recordCanReshare = None
    recordCanEdit = None
    recordForce = True
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
        recordSource = args.source
    if args.destination:
        recordDestination = args.destination
    if args.can-reshare:
        recordCanReshare = args.can-reshare
    if args.can-edit:
        recordCanEdit = args.can-edit
    if args.force:
        recordForce = args.force
    if args.ausername:
        authUsername = args.ausername
    if args.apassword:
        authPassword = args.apassword

    while not my_params.user:
        my_params.user = authUsername

    while not my_params.password:
        my_params.password = authPassword
    api.sync_down(my_params)

    # KEEPER COMMAND
    command = FolderMoveCommand()
    recordResult = command.execute(my_params, src=recordSource, dst=recordDestination, can-reshare=recordCanReshare, can-edit=recordCanEdit, force=recordForce)
    print("Success")
    return recordResult

if __name__ == "__main__":
    main(sys.argv[1:])
