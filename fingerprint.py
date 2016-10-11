from uuid import getnode as get_mac
import platform
import hashlib

#Written in python 2.7.10
#Take device's MAC and uname info to create fingerprint of system

#Alex Shell 5/15/2016

macAddress = hex(get_mac())
unameInfo = ''.join(platform.uname())

fp = hashlib.md5()
fp.update(macAddress)
fp.update(unameInfo)
print "Fingerprint: " + fp.hexdigest()

