import socket
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-d','--dest', help='Destination Host', required=True)
parser.add_argument('-p','--port', help='Destination Port Number (Integer)', required=True, type=int, default=22)
args = parser.parse_args()
	
s = socket.socket()
host = args.dest
port = args.port
try:
    s.connect((host, port))
    print("Connection to host:%s at port:%d is Successful!" % (host, port))
    # originally, it was
    # except Exception, e:
    # but this syntax is not supported anymore.
except Exception as e:
    print("something's wrong with %s:%d. Exception is %s" % (host, port, e))
finally:
    s.close()


