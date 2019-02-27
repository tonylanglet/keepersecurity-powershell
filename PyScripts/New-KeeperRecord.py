import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.record import RecordAddCommand
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
	parser.add_argument('-t', '--title', type=str, help='Title for the record')
	parser.add_argument('-l', '--login', type=str, help='Login for the record')
	parser.add_argument('-p', '--password', type=str, help='Password for the record, if left empty a Keeper generated password will be made')
	parser.add_argument('-u', '--url', type=str, help='URL for the record')
	parser.add_argument('-c', '--customfields', type=str, help='Custom Fields for the record, syntax being used "key1=value1,key2=value2"')
	parser.add_argument('-f', '--folder', type=str, help='Folder uid for the record')
	parser.add_argument('-n', '--notes', type=str, help='Notes for the record')
	parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
	parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
	args = parser.parse_args()

	Parameters = dict()
	Parameters.update({'force':True})
	if args.title is not None:
		Parameters.update({'title':args.title})
	if args.login is not None:
		Parameters.update({'login':args.login})
	if args.password is not None:
		Parameters.update({'pass':args.password})
	else: 
		Parameters.update({'generate':True})
	if args.url is not None:
		Parameters.update({'url':args.url})
	if args.customfields is not None:
		Parameters.update({'custom':args.customfields})
	if args.folder is not None:
		Parameters.update({'folder':args.folder})
	if args.notes is not None:
		Parameters.update({'notes':args.notes})

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
	print(Parameters)
	command = RecordAddCommand()
	record_uid = command.execute(my_params, **Parameters)
	print("Successfully created record [",record_uid,"]")
	return record_uid

if __name__ == "__main__":
    main(sys.argv[1:])
