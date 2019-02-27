import sys
import getopt
import getpass
import string
import argparse

from keepercommander.record import Record
from keepercommander.commands.register import AuditReportCommand
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
    parser.add_argument('-sh', '--syntax-help', help='display help')
    parser.add_argument('-rt', '--report-type', choices=['raw', 'dim', 'hour', 'day', 'week', 'month', 'span'], help='report type')
    parser.add_argument('-rf', '--report-format', choices=['message', 'fields'], help='output format (raw reports only)')
    parser.add_argument('-cs', '--columns', help='Can be repeated. (ignored for raw reports)')
    parser.add_argument('-a', '--aggregate', choices=['occurrences', 'first_created', 'last_created'], help='aggregated value. Can be repeated. (ignored for raw reports)')
    parser.add_argument('-t', '--timezone', help='return results for specific timezone')
    parser.add_argument('-l', '--limit', type=int, help='maximum number of returned rows')
    parser.add_argument('-o', '--order', choices=['desc', 'asc'], help='sort order')
    parser.add_argument('-c', '--created', help='Filter: Created date. Predefined filters: today, yesterday, last_7_days, last_30_days, month_to_date, last_month, year_to_date, last_year')
    parser.add_argument('-et', '--event-type', help='Filter: Audit Event Type')
    parser.add_argument('-u', '--username', help='Filter: Username of event originator')
    parser.add_argument('-tu', '--to-username', help='Filter: Username of event target')
    parser.add_argument('-r', '--record-uid',  help='Filter: Record UID')
    parser.add_argument('-sf', '--shared-folder-uid', help='Filter: Shared Folder UID')
    parser.add_argument('-auser', '--ausername', type=str, help='Authentication username', required=True)
    parser.add_argument('-apass', '--apassword', type=str, help='Authentication password', required=True)
    args = parser.parse_args()

    Parameters = dict()
    if args.syntax-help is not None:
        Parameters.Update('syntax-help',args.syntax-help)
    if args.report-type is not None:
        Parameters.Update('report-type',args.report-type)
    if args.report-format is not None:
        Parameters.Update('report-format',args.report-format)
    if args.columns is not None:
        Parameters.Update('columns',args.columns)
    if args.aggregate is not None:
        Parameters.Update('taraggregateget',args.aggregate)
    if args.timezone is not None:
        Parameters.Update('timezone',args.timezone)
    if args.limit is not None:
        Parameters.Update('limit',args.limit)
    if args.order is not None:
        Parameters.Update('order',args.order)
    if args.created is not None:
        Parameters.Update('created',args.created)
    if args.event-type is not None:
        Parameters.Update('event-type',args.event-type)
    if args.username is not None:
        Parameters.Update('username',args.username)
    if args.to-username is not None:
        Parameters.Update('to-username',args.to-username)
    if args.record-uid is not None:
        Parameters.Update('record-uid',args.record-uid)
    if args.shared-folder-uid is not None:
        Parameters.Update('shared-folder-uid',args.shared-folder-uid)
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
    command = AuditReportCommand()
    result = command.execute(my_params, **Parameters)
    print("Successfully")
    return result

if __name__ == "__main__":
    main(sys.argv[1:])
