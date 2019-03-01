import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordDeleteAttachmentCommand
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
    parser.add_argument("-r", "--record", action='store', help="record UID", required=True)
    parser.add_argument("-n", "--name", dest='name', action='append', help="name of the attachment file", required=True)
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username", required=True)
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password", required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.record is not None:
        Parameters.update({'record':args.record})
    if args.name is not None:
        Parameters.update({'name':args.name})
            
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
    command = RecordDeleteAttachmentCommand()
    result = command.execute(my_params, **Parameters)
    print("Successfully")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
