import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.folder import FolderLinkCommand
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
    parser.add_argument('-src', '--source', type=str, help='sourch path to folder&record or UID')
    parser.add_argument('-dst', '--destination', type=str, help='destination folder or UID')
    parser.add_argument('-s', '--can-reshare', type=str, help='anyone can reshare records')
    parser.add_argument('-e', '--can-edit', type=str, help='anyone can edit records')
    parser.add_argument('-f', '--force', type=str, help='do not prompt', default=True)
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    Parameters.update({'force':True})
    if args.source:
        Parameters.update({'src':args.source})
    if args.destination:
        Parameters.update({'dst':args.destination})
    if args.can-reshare:
        Parameters.update({'can-reshare':args.can-reshare})
    if args.can-edit:
        Parameters.update({'can-edit':args.can-edit})
            
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
    command = FolderMoveCommand()
    result = command.execute(my_params, **Parameters)
    print("Success")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
