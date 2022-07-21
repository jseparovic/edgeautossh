#!/bin/bash

main() {
  source /etc/autosshwrap/autosshwrap.conf
  
  # create authorized keys file if not exists
  if [[ ! -e ${AUTHORIZED_KEYS_FILE} ]]; then
      mkdir -p $(dirname ${AUTHORIZED_KEYS_FILE})
      touch ${AUTHORIZED_KEYS_FILE}
      chmod 644 ${AUTHORIZED_KEYS_FILE}
  fi
  
  # add jump public key if not present
  if ! grep -q "\"${AUTO_SSH_JUMP_PUBLIC_KEY}\"" ${AUTHORIZED_KEYS_FILE}
  then
    echo ${AUTO_SSH_JUMP_PUBLIC_KEY} >> ${AUTHORIZED_KEYS_FILE}
  fi
  
  # get a random port in the range
  port=$(shuf -i ${AUTO_SSH_WRAP_PORT_RANGE} -n 1)
  
  # write the remote port to the jump server so it can connect to us
  dvar=$(dmidecode -s ${DMIDECODE_VARIABLE})
  dmidecode > /tmp/${dvar}.${port}
  scp \
    -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=ERROR -i /etc/autossh/id_rsa \
    /tmp/${dvar}.${port} ${AUTO_SSH_WRAP_JUMP_SERVER}:~
  
  # Start autossh in the foreground so it restarts by supervisord on failure
  /usr/bin/autossh -M ${AUTO_SSH_MONITORING_PORT} -N -R ${port}:127.0.0.1:22 \
    -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=ERROR -i /etc/autossh/id_rsa \
    -p ${AUTO_SSH_WRAP_JUMP_PORT} ${AUTO_SSH_WRAP_JUMP_USER}@${AUTO_SSH_WRAP_JUMP_SERVER}
}


main 2>&1 | xargs -d '\n' -I {} date '+%F %T.%3N {}' | tee -a /var/log/autosshwrap.log

