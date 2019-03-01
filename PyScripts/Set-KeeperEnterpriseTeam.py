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
    parser.add_argument('--team', type=str, action='store', help='team id')
    parser.add_argument('--add-user', dest='add_user', action='append', help='add user to team')
    parser.add_argument('--remove-user', dest='remove_user', action='append', help='remove user to team')
    parser.add_argument('--restrict-edit', dest='restrict_edit', choices=['on', 'off'], action='store', help='restrict edit')
    parser.add_argument('--restrict-share', dest='restrict_share', choices=['on', 'off'], action='store', help='restrict share')
    parser.add_argument('--restrict-view', dest='restrict_view', choices=['on', 'off'], action='store', help='restrict view')
    parser.add_argument('--node', dest='node', action='store', help='node name or uid')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    Parameters.update({'force':True})
    if args.team is not None:
        Parameters.Update({'team':args.team})
    if args.add_user is not None:
        Parameters.Update({'add_user':args.add_user})
    if args.remove_user is not None:
        Parameters.Update({'remove_user':args.remove_user})
    if args.restrict_edit is not None:
        Parameters.Update({'restrict_edit':args.restrict_edit})
    if args.restrict_share is not None:
        Parameters.Update({'restrict_share':args.restrict_share})
    if args.restrict_view is not None:
        Parameters.Update({'restrict_view':args.restrict_view})
    if args.node is not None:
        Parameters.Update({'node':args.node})
            
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
