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
    parser.add_argument('-uf', '--user-folder', type=str, help='create user folder', required=True)
    parser.add_argument('-a', '--all', type=str, help='anyone has all permissions by default')
    parser.add_argument('-u', '--manage-user', type=str, help='anyone can manage users by default')
    parser.add_argument('-r', '--manager-record', type=str, help='anyone can manage records by default')
    parser.add_argument('-s', '--can-share', type=str, help='anyone can share records by default')
    parser.add_argument('-e', '--can-edit', type=str, help='anyone can edit records by default')
    parser.add_argument('-f', '--folder', type=str, help='folder path folderUID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.user-folder is not None:
        Parameters.update({'user-folder':args.user-folder})
    if args.all is not None:
        Parameters.update({'all':args.all})
    if args.manage-user is not None:
        Parameters.update({'manage-user':args.manage-user})
    if args.manager-record is not None:
        Parameters.update({'manager-record':args.manage-record})
    if args.can-share is not None:
        Parameters.update({'can-share':args.can-share})
    if args.can-edit is not None:
        Parameters.update({'can-edit':args.can-edit})
    if args.folder is not None:
        Parameters.update({'folder':args.folder})
            
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
