#!/bin/bash

echo "[INFO] Starting network services..."

##########################

/etc/init.d/rsyslog start >/dev/null 2>/dev/null
/etc/init.d/nginx start >/dev/null 2>/dev/null
/etc/init.d/vsftpd start >/dev/null 2>/dev/null
/etc/init.d/tftpd-hpa start >/dev/null 2>/dev/null
sleep 1

##########################

# snmpd hangs after stop, it needs to be killed manually
/etc/init.d/snmpd stop >/dev/null 2>/dev/null
sleep 1
kill "$(cat /run/snmpd.pid 2>/dev/null)" 2>/dev/null || true
/etc/init.d/snmpd start >/dev/null 2>/dev/null
/etc/init.d/snmptrapd start >/dev/null 2>/dev/null

##########################

mkdir -p /run/sshd
chmod 755 /run/sshd

sed -i 's/^#\?\(PermitRootLogin\s\+\).*$/\1yes/' /etc/ssh/sshd_config
sed -i 's/^#\?\(PasswordAuthentication\s\+\).*$/\1yes/' /etc/ssh/sshd_config

/usr/sbin/sshd

##########################

clear

echo "[INFO] Networkers' Toolkit ready."

ONBOOT_SCRIPT="/etc/onboot.sh"

if [ ! -f "$ONBOOT_SCRIPT" ]; then
    echo "#!/bin/bash" > "$ONBOOT_SCRIPT"
    chmod +x "$ONBOOT_SCRIPT"
    echo "[INFO] Created empty $ONBOOT_SCRIPT."
fi

"$ONBOOT_SCRIPT"

cd
exec bash -i
