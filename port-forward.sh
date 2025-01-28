#!/usr/bin/bash
SRC="$1"
DEST="$2"

if [ -z $SRC ] || [ -z $DEST ];then
    echo "USAGE: ./port-forward.sh <src-port> <dest-port>"
    exit 1
fi

# Forward incoming traffic on port $SRC to port DEST
sudo iptables -t nat -A PREROUTING -i br0 -p tcp --dport $SRC -j REDIRECT --to-port $DEST

# Optionally, if you want to allow the traffic through the filter table
sudo iptables -A INPUT -p tcp --dport $SRC -j ACCEPT

# Add to cron
sudo echo "-- Adding /etc/cron.d/portfwd-$SRC-$DEST"
sudo echo "@reboot /usr/sbin/iptables -t nat -A PREROUTING -i br0 -p tcp --dport $SRC -j REDIRECT --to-port $DEST" > /etc/cron.d/portfwd-$SRC-$DEST
sudo echo "@reboot /usr/sbin/iptables -A INPUT -p tcp --dport $SRC -j ACCEPT" >> /etc/cron.d/portfwd-$SRC-$DEST
