import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.enterprise import EnterpriseTeamCommand
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
    parser.add_argument('--add',  dest='add', action='store_true', help='create team')
    parser.add_argument('--add-user', dest='add_user', action='append', help='add user to team')
    parser.add_argument('--restrict-edit', dest='restrict_edit', choices=['on', 'off'], action='store', help='restrict edit for the team')
    parser.add_argument('--restrict-share', dest='restrict_share', choices=['on', 'off'], action='store', help='restrict sharing for the team')
    parser.add_argument('--restrict-view',dest='restrict_view', choices=['on', 'off'], action='store', help='restrict viewing for the team')
    parser.add_argument('--node', dest='node', action='store', help='remove user from role')
    parser.add_argument('--team', type=str, action='store', help='Team name or UID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.add is not None:
        Parameters.update({'add',args.add})
    if args.add_user is not None:
        Parameters.update({'add_user',args.add_user})
    if args.restrict_edit is not None:
        Parameters.update({'restrict_edit',args.restrict_edit})
    if args.restrict_share is not None:
        Parameters.update({'restrict_share',args.restrict_share})
    if args.restrict_view is not None:
        Parameters.update({'restrict_view',args.restrict_view})
    if args.node is not None:
        Parameters.update({'node',args.node})
    if args.team is not None: 
        Parameters.update({'team',args.team})
            
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
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
