#!/bin/bash

# Update the Proxmox VE Enterprise repository list
echo "Disabling the Enterprise repository..."
#sed -i 's/^/#/' /etc/apt/sources.list.d/pve-enterprise.list
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.disabled

# Add the No-Subscription repository
echo "Adding the No-Subscription repository..."
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >> /etc/apt/sources.list.d/pve.list

# Update the Ceph repository list
echo "Updating the Ceph repository list..."
mv /etc/apt/sources.list.d/ceph.list /etc/apt/sources.list.d/ceph-enterprise.list.disabled
echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" >> /etc/apt/sources.list.d/ceph.list

# Update the package lists and upgrade the system
echo "Updating package lists and upgrading the system..."
apt update && apt upgrade -y
#apt update && apt dist-upgrade -y

echo "Proxmox VE No-Subscription Repository configuration complete."
