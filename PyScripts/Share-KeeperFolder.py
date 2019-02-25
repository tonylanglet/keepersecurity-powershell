mport sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.register import ShareFolderCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()
      
# MAIN FUNCTION
def main(argv):
    # Variables
    shareFolder = None
    shareUser = None
    shareAction = None
    shareRecord = None
    shareManageRecords = None
    shareManageUsers = None
    shareCanShare = None
    shareCanEdit = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    #Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--folder', type=str, help='Record UID', required=True)
    parser.add_argument('-u', '--user', type=str, help='account email, team, or \'*\' as default folder permission')
    parser.add_argument('-a', '--action', choices=['grant', 'revoke'], default='grant', help='user share action. \'grant\' if omitted')
    parser.add_argument('-r', '--record', type=str, help='record name, record UID, or \'*\' as default folder permission')
    parser.add_argument('-p', '--manage-records', type=str, help='account permission: can manage records.')
    parser.add_argument('-o', '--manage-users', type=str, help='account permission: can manage users.')
    parser.add_argument('-s', '--can-share', type=str, help='record permission: can be shared')
    parser.add_argument('-e', '--can-edit', type=str, help='record permission: can be modified.')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    if args.folder:
        shareFolder = args.folder
    if args.user:
        shareUser = args.user
    if args.action:
        shareAction = args.action
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
    command = ShareFolderCommand()
    result = command.execute(my_params, folder=shareFolder, action=shareAction, user=shareUser, record=shareRecord, manage-records=shareManageRecords, manage-users=shareManageUsers, can-share=shareCanShare, can-edit=shareCanEdit)
    print("Successfully")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
