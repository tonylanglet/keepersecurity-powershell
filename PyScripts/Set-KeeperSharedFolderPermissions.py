import sys
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
    # Authentication credentials
    authUsername = None
    authPassword = None

    #Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--folder', nargs='?', type=str, action='store', help='Record UID', required=True)
    parser.add_argument('--user', dest='user', action='append', help='account email, team, or \'*\' as default folder permission')
    parser.add_argument('--action', dest='action', choices=['grant', 'revoke'], default='grant', action='store', help='user share action. \'grant\' if omitted')
    parser.add_argument('--record', dest='record', action='append', help='record name, record UID, or \'*\' as default folder permission')
    parser.add_argument('--manage-records', dest='manage_records', type=bool, help='account permission: can manage records.')
    parser.add_argument('--manage-users', dest='manage_users', type=bool, help='account permission: can manage users.')
    parser.add_argument('--can-share', dest='can_share', type=bool, help='record permission: can be shared')
    parser.add_argument('--can-edit', dest='can_edit', type=bool, help='record permission: can be modified.')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.folder is not None:
        Parameters.update({'folder':args.folder})
    if args.user is not None:
        Parameters.update({'user':args.user})
    if args.action is not None:
        Parameters.update({'action':args.action})
    if args.record is not None:
        Parameters.update({'record':args.record})
    if args.manage_records is not None:
        Parameters.update({'manage_records':args.manage_records})
    if args.manage_users is not None:
        Parameters.update({'manage_users':args.manage_users})
    if args.can_share is not None:
        Parameters.update({'can_share':args.can_share})
    if args.can_edit is not None:
        Parameters.update({'can_edit':args.can_edit})
            
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
    result = command.execute(my_params, **Parameters)
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
