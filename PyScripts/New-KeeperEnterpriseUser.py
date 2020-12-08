import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.enterprise import EnterpriseUserCommand
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
    parser.add_argument('--email', type=str, action='store', help='user email or user ID or user search pattern')
    parser.add_argument('--name', dest='displayname', action='store', help='set user name')
    parser.add_argument('--node', dest='node', action='store', help='node name or node ID')
    parser.add_argument('--add-role', dest='add_role', action='append', help='role name or role ID')
    parser.add_argument('--add-team', dest='add_team', action='append', help='team name or team ID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    Parameters.update({'force':True})
    Parameters.update({'add':True})
    if args.email is not None:
        Parameters.update({'email':args.email})
    if args.displayname is not None:
        Parameters.update({'displayname':args.displayname})        
    if args.node is not None:
        Parameters.update({'node':args.node})
    if args.add_role is not None:
        Parameters.update({'add_role':args.add_role})
    if args.add_team is not None:
        Parameters.update({'add_team':args.add_team})
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
    command = EnterpriseUserCommand()
    result = command.execute(my_params, **Parameters)
    print(result)
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
