import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordGetUidCommand
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
    parser.add_argument('-fo', '--folder', type=str, help='Folder uid', required=True)
    parser.add_argument('-f', '--format', type=str, choices=['json','detail'], help='format json/detail', default='json')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username')
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password')
    args = parser.parse_args()

    Parameters = dict()
    if args.folder is not None:
        Parameters.update({'uid':args.folder})
    if args.format is not None:
        Parameters.update({'format':args.format})
            
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
    command = RecordGetUidCommand()
    result = command.execute(my_params, **Parameters)
    print("Successfully fetched record [",recordUid,"]")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
