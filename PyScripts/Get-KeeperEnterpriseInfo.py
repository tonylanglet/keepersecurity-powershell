import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.enterprise import EnterpriseInfoCommand
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
    parser.add_argument('-ns', '--nodes', type=str, help='print node tree')
    parser.add_argument('-u', '--users', type=str, help='print user list')
    parser.add_argument('-t', '--teams', type=str, help='print team list')
    parser.add_argument('-r', '--roles', type=str, help='print role list')
    parser.add_argument('-n', '--node', type=str, help='limit results to node (name or ID)')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.nodes is not None:
        Parameters.update({'nodes':args.nodes)}
    if args.users is not None:
        Parameters.update({'users':args.users)}
    if args.roles is not None:
        Parameters.update({'roles':args.roles)}
    if args.teams is not None:
        Parameters.update({'teams':args.teams)}
    if args.node is not None:
       Parameters.update({'node':args.node)}
                          
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
    command = EnterpriseInfoCommand()
    recordResult = command.execute(my_params, **Parameters)
    print("Success")
    return recordResult

if __name__ == "__main__":
    main(sys.argv[1:])
