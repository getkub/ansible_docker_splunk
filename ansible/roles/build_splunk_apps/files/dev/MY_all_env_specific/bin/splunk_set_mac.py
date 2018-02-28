
# Append OPTIMISTIC_ABOUT_FILE_LOCKING in $SPLUNK_HOME/etc/splunk-launch.conf

import os

sFile = '/opt/splunk/etc/splunk-launch.conf'

if os.path.exists(sFile):
    append_write = 'a' # append if already exists
else:
    append_write = 'w' # make a new file if not

sFileObj = open(sFile,append_write)
sFileObj.write("\nOPTIMISTIC_ABOUT_FILE_LOCKING = 1\n")
sFileObj.close()

sFile2 = '/opt/splunk/etc/sample.temp'
if os.path.exists(sFile2):
    append_write = 'a' # append if already exists
else:
    append_write = 'w' # make a new file if not

sFileObj2 = open(sFile2,append_write)
sFileObj2.write("\nTest Writing\n")
sFileObj2.close()
