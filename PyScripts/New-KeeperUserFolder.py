import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderMakeCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()
      
# MAIN FUNCTION
def main(argv):
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--all', dest='grant', action='store_true', help='anyone has all permissions by default')
    parser.add_argument('--manage-user', dest='manage_users', action='store_true', help='anyone can manage users by default')
    parser.add_argument('--manage-record', dest='manage_records', action='store_true', help='anyone can manage records by default')
    parser.add_argument('--can-share', dest='can_share', action='store_true', help='anyone can share records by default')
    parser.add_argument('--can-edit', dest='can_edit', action='store_true', help='anyone can edit records by default')
    parser.add_argument('--name', nargs='?', type=str, action='store', help='folder path folderUID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    Parameters.update({'user_folder':True})
    if args.all is not None:
        Parameters.update({'all':args.all})
    if args.manage_user is not None:
        Parameters.update({'manage-user':args.manage_user})
    if args.manage_record is not None:
        Parameters.update({'manager-record':args.manage_record})
    if args.can_share is not None:
        Parameters.update({'can_share':args.can_share})
    if args.can_edit is not None:
        Parameters.update({'can_edit':args.can_edit})
    if args.name is not None:
        Parameters.update({'folder':args.name})
            
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
    command = FolderMakeCommand()
    result = command.execute(my_params, **Parameters)
    print("Success")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
