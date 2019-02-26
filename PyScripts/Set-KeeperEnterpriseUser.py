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
    # Variables
    entUserEmail = None
    entUserLock = None
    entUserUnlock = None
    entUserName = None
    entUserAddRole = None
    entUserAddTeam = None
    entUserRemoveTeam = None
    entUserRemoveRole = None
    entUserNode = None
    endUserExpire = None
    entUserForce = True
    # Authentication credentials
    authUsername = None
    authPassword = None

    #Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-e', '--email', type=str, help='user email or user ID or user search pattern')
    parser.add_argument('-n', '--name', type=str, help='set user name')
    parser.add_argument('-l', '--lock', type=str, help='invite user')
    parser.add_argument('-ul', '--unlock', type=str, help='invite user')
    parser.add_argument('-no', '--node', type=str, help='node name or node ID')
    parser.add_argument('-ar', '--add-role', type=str, help='role name or role ID')
    parser.add_argument('-rr', '--remove-role', type=str, help='role name or role ID')
    parser.add_argument('-at', '--add-team', type=str, help='team name or team ID')
    parser.add_argument('-rt', '--remove-team', type=str, help='team name or team ID')
    parser.add_argument('-expass', '--expire', type=str, help='team name or team ID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    if args.email:
        entUserEmail = args.email
    if args.name:
        entUserName = args.name
    if args.lock:
        entUserLock = args.lock
    if args.unlock:
        entUserUnlock = args.unlock
    if args.node:
        entUserNode = args.node
    if args.add-role:
        entUserAddRole = args.add-role
    if args.remove-role:
        entUserRemoveRole = args.remove-role
    if args.add-team:
        entUserAddTeam = args.add-team
    if args.remove-team:
        entUserRemoveTeam = args.remove-team
    if args.expire:
        entUserExpire = args.expire
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
    result = command.execute(my_params, email=entUserEmail, lock=entUserLock, unlock=entUserUnlock, name=entUserName, node=entUserNode, add-role=entUserAddRole, remove-role=entUserRemoveRole, add-team=entUserAddTeam, remove-team=entUserRemoveTeam, expire=entUserExpire, force=entUserForce)
    print("Successfully")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
