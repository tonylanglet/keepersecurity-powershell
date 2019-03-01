import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.register import EnterpriseRoleCommand
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
    parser.add_argument('--role', type=str, action='store', help='role id')
    parser.add_argument('--add-user', dest='add_user', action='append', help='add user to role')
    parser.add_argument('--remove-user', dest='remove_user', action='append', help='remove user from role')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.role is not None:
        Parameters.update({'role':args.role})
    if args.add_user is not None:
        Parameters.update({'add_user':args.add_user})
    if args.remove_user is not None:
        Parameters.update({'remove_user':args.remove_user})
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
    command = EnterpriseRoleCommand()
    result = command.execute(my_params, **Parameters)
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
