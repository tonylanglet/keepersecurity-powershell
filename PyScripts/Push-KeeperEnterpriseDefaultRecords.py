import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.enterprise import EnterprisePushCommand
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
    parser.add_argument('--file', nargs='?', type=str, action='store', help='file name in JSON format that contains template records')
    parser.add_argument('--user', dest='user', action='append', help='User email or User ID. Records will be assigned to the user.')
    parser.add_argument('--team', dest='team', action='append', help='Team name or team UID. Records will be assigned to all users in the team.')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.file is not None:
        Parameters.update({'file',args.file})
    if args.user is not None:
        Parameters.update({'user',args.user})
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
    command = EnterprisePushCommand()
    result = command.execute(my_params, **Parameters)
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
