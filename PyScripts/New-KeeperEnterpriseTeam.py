import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.register import EnterpriseTeamCommand
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
    parser.add_argument('-a', '--add', type=str, help='add user to role')
    parser.add_argument('-au', '--add-user', type=str, help='add user to team')
    parser.add_argument('-re', '--restrict-edit', type=str, help='remove user from role')
    parser.add_argument('-rs', '--restrict-share', type=str, help='remove user from role')
    parser.add_argument('-rv', '--restrict-view', type=str, help='remove user from role')
    parser.add_argument('-no', '--node', type=str, help='remove user from role')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.add is not None:
        Parameters.Update('add',args.add)
    if args.add-user is not None:
        Parameters.Update('add-user',args.add-user)
    if args.restrict-edit is not None:
        Parameters.Update('restrict-edit',args.restrict-edit)
    if args.restrict-share is not None:
        Parameters.Update('restrict-share',args.restrict-share)
    if args.restrict-view is not None:
        Parameters.Update('restrict-view',args.restrict-view)
    if args.node is not None:
        Parameters.Update('noder',args.node)
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
    command = EnterpriseTeamCommand()
    result = command.execute(my_params, **Parameters)
    print("Successfully")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
