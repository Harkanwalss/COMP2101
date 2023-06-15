#!/bin/bash
#sysinfo script for lab 4

myhostname=$(hostname)
mydate=$(date)

mycpu=$( lscpu|grep 'Model name:'|sed 's/.*Model name: *//')
mycpucurrentspeed=$(sudo lshw -class processor| grep size|tail -1|awk '{print $2}' )
mycpumaxspeed=$(sudo lshw -class processor| grep capacity|tail -1|awk '{print $2}' )

source /etc/os-release

myfqdn=$(hostname -f)
if [[ ! $myfqdn =~ '.' ]]; then
	myfqdn+=" (no domain name available)"
fi

cat <<EOF

System info report produced by $USER on $mydate

System Info
-----------
Hostname: $myfqdn
OS:       $PRETTY_NAME

Processor Info
--------------
CPU Model:     $mycpu
Current Speed: $mycpucurrentspeed
Max Speed:     $mycpumaxspeed

EOF
