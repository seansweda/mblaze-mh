#!/usr/bin/python

import os
import sys
import imaplib

imap_bin = '/usr/libexec/dovecot/imap'
imap_opts = []

try:
    folder = sys.argv[1]
except IndexError as err:
    print( "usage: %s <folder>" % sys.argv[0] )
    sys.exit(1)

if 'IMAP_OPTS' in list(os.environ.keys()):
    imap_opts = os.environ.get('IMAP_OPTS').split(':')

if folder[0] == '.':
    folder = folder[1:]

imap_cmd = imap_bin
for o in imap_opts:
    imap_cmd += ' -o '
    imap_cmd += o

print( imap_cmd, folder )
i = imaplib.IMAP4_stream( imap_cmd )

c = i.select( folder )
if c[0] != 'OK':
    print( c )
    i.logout()
    sys.exit(1)

c = i.expunge()
if c[0] == 'OK':
    i.close()
    i.logout()
else:
    print( c )
    i.logout()
    sys.exit(1)

