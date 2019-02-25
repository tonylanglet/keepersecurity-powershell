import sys
import getopt
import getpass
import string
import re
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordDeleteAttachmentCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# KEEPER COMMAND
def del_recordatt(recordUID, attName):
    command = RecordDeleteAttachmentCommand()
    recordResult = command.execute(my_params, record=recordUID, name=attName)
    print("Successfully")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Variables
    recordUID = None
    attName = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-r", "--record", type=str, help="Folder UID", required=True)
    parser.add_argument("-n", "--name", type=str, help="force y/n, true/false", default=True)
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username", required=True)
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password", required=True)
    args = parser.parse_args()

    if args.record:
        recordUID = args.record
    if args.name:
        attName = args.name
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
    result = del_recordatt(recordUID, attName)

if __name__ == "__main__":
    main(sys.argv[1:])
