#!/bin/bash

cat <<EOF >/etc/cron.weekly/fstrim
#!/bin/sh
fstrim /
EOF

chmod +x /etc/cron.weekly/fstrim
