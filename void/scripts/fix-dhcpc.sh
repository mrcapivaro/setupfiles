#!/bin/bash
ln -s /etc/sv/dhcpcd /var/service
sv start dhcpcd
