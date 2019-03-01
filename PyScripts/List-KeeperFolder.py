import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderListCommand
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
    parser.add_argument('--list', dest='detail', action='store_true', help='show detailed list')
    parser.add_argument('--folders', dest='folders', action='store_true', help='display folders')
    parser.add_argument('--records', dest='records', action='store_true', help='display records')
    parser.add_argument('--pattern', nargs='?', type=str, action='store', help='search pattern')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.list is not None:
        Parameters.update({'list':args.list})
    if args.folders is not None:
        Parameters.update({'folders':args.folders})
    if args.records is not None:
        Parameters.update({'records':args.records})
    if args.pattern is not None:
        Parameters.update({'pattern':args.pattern})
            
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
    command = FolderListCommand()
    result = command.execute(my_params, **Parameters)
    print("Success")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
