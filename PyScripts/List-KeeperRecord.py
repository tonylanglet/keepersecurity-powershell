import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordListCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# KEEPER COMMAND
def lst_record(recordPattern):
    command = RecordListCommand()
    recordResult = command.execute(my_params, pattern=recordPattern)
    print("List successfully fetched")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Variables
    recordPattern = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pattern", type=str, help="Pattern for search")
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username")
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password")
    args = parser.parse_args()

    if args.pattern:
        recordPattern = args.pattern
    if args.ausername:
        authUsername = args.ausername
    if args.apassword:
        authPassword = args.apassword
    
    while not my_params.user:
        my_params.user = authUsername

    while not my_params.password:
        my_params.password = authPassword
    api.sync_down(my_params)

    # Start function
    result = lst_record(recordPattern)

if __name__ == "__main__":
    main(sys.argv[1:])
