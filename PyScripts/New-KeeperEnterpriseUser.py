import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.register import EnterpriseUserCommand
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
    parser.add_argument('-e', '--email', type=str, help='user email or user ID or user search pattern')
    parser.add_argument('-n', '--name', type=str, help='set user name')
    parser.add_argument('-no', '--node', type=str, help='node name or node ID')
    parser.add_argument('-ar', '--add-role', type=str, help='role name or role ID')
    parser.add_argument('-at', '--add-team', type=str, help='team name or team ID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    Parameters.update({'force':True})
    Parameters.update({'add':True})
    if args.email is not None:
        Parameters.update({'email':args.email})
    if args.name is not None:
        Parameters.update({'name':args.name})        
    if args.node is not None:
        Parameters.update({'node':args.node})
    if args.add-role is not None:
        Parameters.update({'add-role':args.add-role})
    if args.add-team is not None:
        Parameters.update({'add-team':args.add-team})
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
    result = command.execute(my_params, email=entUserEmail, add=entUserAdd, name=entUserName, node=entUserNode, add-role=entUserAddRole, add-team=entUserAddTeam, force=entUserForce)
    print("Successfully")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
