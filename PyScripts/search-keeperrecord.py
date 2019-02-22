import sys
import getopt
import getpass
import string
import random

from keepercommander.record import Record
from keepercommander.commands.record import SearchCommand
from keepercommander.params import KeeperParams
from keepercommander import display, api

my_params = KeeperParams()

# KEEPER COMMAND
def search_record(recordPattern):
    command = SearchCommand()
    recordResult = command.execute(my_params, pattern=recordPattern)
    print("Search complete")
    return recordResult
      
# MAIN FUNCTION
def main(argv):
    # Record parameters
    recordPattern = None
    # Authentication credentials
    authUsername = None
    authPassword = None

    # Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--pattern", type=str, help="Search pattern", required=True)
    parser.add_argument("-auser", "--ausername", type=str, help="Authentication username", required=True)
    parser.add_argument("-apass", "--apassword", type=str, help="Authentication password", required=True)
    args = parser.parse_args()

    if args.pattern:
        recordPattern = args.pattern
    if args.ausername:
        authUsername = args.ausername
    if args.apassword:
        authPassword = args.apassword
    
    try:
        opts, args = getopt.getopt(argv,"h:p:",["pattern=","ausername=","apassword="])
    except getopt.GetoptError:
        print('search-keeperrecord.py -pattern|p <Search pattern> --ausername <AuthUsername> --apassword <AuthPAssword>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('search-keeperrecord.py -pattern|p <Search pattern> --ausername <AuthUsername> --apassword <AuthPAssword>')
            sys.exit()
        elif opt in ("-p", "--pattern"):
            recordPattern = arg
        elif opt in "--ausername":
            authUsername = arg
        elif opt in "--apassword":
            authPassword = arg

    while not my_params.user:
        my_params.user = authUsername

    while not my_params.password:
        my_params.password = authPassword
    api.sync_down(my_params)

    # Start function
    result = search_record(recordPattern)

if __name__ == "__main__":
    main(sys.argv[1:])
