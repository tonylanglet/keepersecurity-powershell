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
    parser.add_argument('-l', '--list', type=str, help='show detailed list')
    parser.add_argument('-f', '--folder', type=str, help='display folders')
    parser.add_argument('-r', '--record', type=str, help='display records')
    parser.add_argument('-p', '--pattern', type=str, help='search pattern')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.list is not None:
        Parameters.update({'list':args.list})
    if args.folder is not None:
        Parameters.update({'folder':args.folder})
    if args.record is not None:
        Parameters.update({'record':args.record})
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
    recordResult = command.execute(my_params, **Parameters)
    print("Success")
    return recordResult

if __name__ == "__main__":
    main(sys.argv[1:])
