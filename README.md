
Edge AutoSSH wrapper for reverse remote access

This package uses systemd to ensure autossh is running

It has currently been tested on Centos 7


To modify config prior to install update files in "files" directory. These are copied to the root directory of the install host. Note the pub/priv key is there for testing only. This must be overwritten prior to use and is in the repo for testing purposes only.


To install run:
```
install.sh
```

Ensure you overwrite the existing pub/priv key which is there for testing only
```
ssh-keygen -q -t rsa -N "" -f /etc/autossh/id_rsa
```
Copy your public key to the jump server authorized_keys file


To start: (it's already enabled in install.sh)
```
systemctl start autosshwrap
```

Logs are in:
```
tail -f /var/log/autosshwrap.log
```



Add to Jump Server /etc/ssh/sshd_config:
```
GatewayPort yes
ClientAliveInterval 15
ClientAliveCountMax 3
```
