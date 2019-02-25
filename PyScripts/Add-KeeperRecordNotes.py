import sys
import getopt
import getpass
import string
import random
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordAppendNotesCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()
      
# MAIN FUNCTION
def main(argv):
    # Variables
    recordUid = None
    recordNotes = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    #Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-r", "--record", type=str, help="Record UID", required=True)
    parser.add_argument("-n", "--notes", type=str, help="Appended notes")
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username", required=True)
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password", required=True)
    args = parser.parse_args()

    if args.record:
        recordUid = args.record
    if args.notes:
        recordNotes = args.notes
    if args.ausername:
        authUsername = args.ausername
    if args.apassword:
        authPassword = args.apassword

    #Authentication login
    while not my_params.user:
        my_params.user = authUsername

    while not my_params.password:
        my_params.password = authPassword
    api.sync_down(my_params)

    # KEEPER COMMAND
    command = RecordAppendNotesCommand()
    recordResult = command.execute(my_params, record=recordUid, notes=recordNotes)
    print("Successfully updated notes on [",recordUid,"] with [", recordNotes ,"]")
    return recordResult

if __name__ == "__main__":
    main(sys.argv[1:])
