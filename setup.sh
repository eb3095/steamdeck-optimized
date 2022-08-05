#!/bin/bash

SSH_INHIBIT_SLEEP=$(cat <<ENDFILE
[Unit]
Description=Prevent sleep when SSH sessions are active
Before=sleep.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c '[ "$(who | grep "pts/")" == "" ]'

[Install]
RequiredBy=sleep.target
ENDFILE
)
SLEEP_RECOVER_PIPEWIRE=$(cat <<ENDFILE
[Unit]
Description=Recover audio when system is woken up
After=sleep.target

[Service]
Type=oneshot
User=deck
Group=deck
ExecStart=/usr/bin/systemctl --user restart pipewire pipewire-pulse

[Install]
WantedBy=sleep.target
ENDFILE
)
INSTALL_SCRIPT=$(cat <<ENDFILE
#!/bin/bash

echo "Enabling Read/Write"
steamos-readonly disable

echo "Setting up services"
systemctl enable /home/deck/.steamdeck-optimize/ssh-inhibit-sleep.service
systemctl enable /home/deck/.steamdeck-optimize/sleep-recover-pipewire.service

echo "Setting up Pacman keys"
pacman-key --init
pacman-key --populate

echo "Installing important packages"
pacman -S ufw --noconfirm

echo "Setting up firewall"
yes | ufw reset
ufw default disable
ufw allow 22
yes | ufw enable

echo "Enabling SSH and securing"
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i -e 's/#X11Forwarding no/X11Forwarding yes/g' /etc/ssh/sshd_config
systemctl enable --now sshd

if ! [ -d /home/deck/.ssh ]; then
    echo "Creating ssh directory and files"
    mkdir /home/deck/.ssh
    touch /home/deck/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 644 ~/.ssh/authorized_keys
fi

echo "Disabling Read/Write"
steamos-readonly enable

echo "All done!"
ENDFILE
)

echo "Welcome to Steam Deck Optimized"
echo "Please wait while we setup your system..."

# Sleep and let users read the info
sleep 3

echo "Creating progam directory at /home/deck/.steamdeck-optimized"
mkdir -p /home/deck/.steamdeck-optimized

echo "Writing files"
echo "${SSH_INHIBIT_SLEEP}" > /home/deck/.steamdeck-optimized/ssh-inhibit-sleep.service
echo "${SLEEP_RECOVER_PIPEWIRE}" > /home/deck/.steamdeck-optimized/sleep-recover-pipewire.service
echo "${INSTALL_SCRIPT}" > /home/deck/.steamdeck-optimized/setup.sh
chmod +x /home/deck/.steamdeck-optimized/setup.sh

echo "Setting up"
/home/deck/.steamdeck-optimized/setup.sh

echo "All done!"
echo "To re-enable Steam Deck Optimized after an update run,"
echo "/home/deck/.steamdeck-optimized/setup.sh"
