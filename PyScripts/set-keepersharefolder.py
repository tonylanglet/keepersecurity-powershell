import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import ShareRecordCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# KEEPER COMMAND
def share_record(recordUID, shareEmail, shareAction, shareShare, shareWrite):
    command = ShareRecordCommand()
    recordResult = command.execute(my_params, record=recordUID,email=shareEmail, action=shareAction, share=shareShare, write=shareWrite )
    print("Successfully")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Variables
    folderUid = None
    shareAction = None
    shareUser = None
    shareRecord = None
    shareManageRecords = None
    shareManageUsers = None
    shareCanShare = None
    shareCanEdit = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--folder", type=str, help="shared folder path or UID", required=True)
    parser.add_argument("-a", "--action", type=str, choices=["grant","revoke"] help="shared folder action. \'grant\' if omitted", required=True)
    parser.add_argument("-u", "--user", type=str, help="account email, team, or \'*\' as default folder permission", required=True)
    parser.add_argument("-r", "--record", type=str, help="record name, record UID, or \'*\' as default folder permission", required=True)
    parser.add_argument("-p", "--manage-records", type=str, help="account permission: can manage records.")
    parser.add_argument("-o", "--manage-users", type=str, help="account permission: can manage users.")
    parser.add_argument("-s", "--can-share", type=str, help="record permission: can be shared")
    parser.add_argument("-e", "--can-edit", type=str, help="record permission: can be modified.")
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username", required=True)
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password", required=True)
    args = parser.parse_args()

    if args.folder:
        folderUid = args.folder
    if args.action:
        shareAction = args.action
    if args.user:
        shareUser = args.user
    if args.record:
        shareRecord = args.record
    if args.manage-records:
        shareManageRecords = args.manage-records
    if args.manage-users:
        shareManageUsers = args.manage-users
    if args.can-share:
        shareCanShare = args.can-share
    if args.can-edit:
        shareCanEdit = args.can-edit
    if args.ausername:
        authUsername = args.apassword
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
