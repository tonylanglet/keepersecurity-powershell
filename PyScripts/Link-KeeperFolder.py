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
    parser.add_argument('-src', '--source', nargs='?', type=str, action='store', help='sourch path to folder&record or UID', required=True)
    parser.add_argument('-dst', '--destination', nargs='?', type=str, action='store', help='destination folder or UID', required=True)
    parser.add_argument('--can-reshare', dest='can_reshare', action='store_true', help='anyone can reshare records')
    parser.add_argument('--can-edit', dest='can_edit', action='store_true', help='anyone can edit records')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    Parameters.update({'force':True})
    if args.source is not None:
        Parameters.update({'src':args.source})
    if args.destination is not None:
        Parameters.update({'dst':args.destination})
    if args.can_reshare is not None:
        Parameters.update({'can_reshare':args.can_reshare})
    if args.can_edit is not None:
        Parameters.update({'can_edit':args.can_edit})

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
    command = FolderLinkCommand()
    result = command.execute(my_params, **Parameters)
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
