import sys
import getopt
import getpass
import string
import random
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import ShareRecordCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# ADD NEW RECORD INTO KEEPER
def share_record(recordUID, shareEmail, shareAction, shareShare, shareWrite):
    # Get Record from Keeper
    command = ShareRecordCommand()
    recordResult = command.execute(my_params, record=recordUID,email=shareEmail, action=shareAction, share=shareShare, write=shareWrite )
    print("Successfully")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Record parameters
    recordUID = None
    shareEmail = None
    shareAction = None
    shareShare = None
    shareWrite = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-r", "--record", type=str, help="Record UID")
    parser.add_argument("-e", "--email", type=str, help="Email")
    parser.add_argument("-a", "--action", type=str, choices=["grant","revoke","owner"], help="Action Grant/Revoke/Owner")
    parser.add_argument("-s", "--share", type=str, help="Share")
    parser.add_argument("-w", "--write", type=str, help="Write")
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username")
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password")
    args = parser.parse_args()

    if args.record:
        recordRecord = args.record
    if args.email:
        recordEmail = args.email
    if args.action:
        recordAction = args.action
    if args.share:
        recordShare = args.share
    if args.write:
        recordWrite = args.write
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
    result = share_record(recordUID, shareEmail, shareAction, shareShare, shareWrite)

if __name__ == "__main__":
    main(sys.argv[1:])
