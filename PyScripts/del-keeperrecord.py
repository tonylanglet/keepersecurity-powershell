import sys
import getopt
import getpass
import string
import random
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordRemoveCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# ADD NEW RECORD INTO KEEPER
def del_record(recordUid, recordFormat):
    # Get Record from Keeper
    command = RecordRemoveCommand()
    recordResult = command.execute(my_params, record=recordUid, force=recordForce)
    print("Successfully deleted record [",recordUid,"]")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Record parameters
    recordUid = None
    recordForce = False
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-r", "--record", type=str, help="Recordc UID")
    parser.add_argument("-f", "--force", type=str, help="Force")
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username")
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password")
    args = parser.parse_args()

    if args.title:
        recordUid = args.record
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

    # Start function
    result = del_record(recordUid, recordForce)

if __name__ == "__main__":
    main(sys.argv[1:])