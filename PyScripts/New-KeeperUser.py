import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.register import RegisterCommand
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
    parser.add_argument('--store-record', dest='store', type=bool, help='store credentials into Keeper record (must be logged in)')
    parser.add_argument('--generate', dest='generate', type=bool, help='generate a password')
    parser.add_argument('-pass', '--password', dest='password', action='store', help='user password')
    parser.add_argument('--data-center', dest='data_center', choices=['us', 'eu'], action='store', help='data center')
    parser.add_argument('--node', dest='node', action='store', help='node name or node ID (enterprise only)')
    parser.add_argument('--name', dest='name', action='store', help='user name (enterprise only)')
    parser.add_argument('--question', dest='question', action='store', help='secret question')
    parser.add_argument('--answer', dest='answer', action='store', help='secret answer')
    parser.add_argument('--email', action='store', help='email')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.store is not None:
        Parameter.update({'store':args.store})
    if args.generate is not None:
        Parameter.update({'generate':args.generate})
    if args.password is not None:
        Parameter.update({'pass':args.password})
    if args.data-center is not None:
        Parameter.update({'data_center':args.data_center})
    if args.node is not None:
        Parameter.update({'node':args.node})
    if args.name is not None:
        Parameter.update({'name':args.name})
    if args.question is not None:
        Parameter.update({'question':args.question})
    if args.answer is not None:
        Parameter.update({'answer':args.answer})
    if args.email is not None:
        Parameter.update({'email':args.email})
            
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
    command = RegisterCommand()
    result = command.execute(my_params, **Parameters)
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
