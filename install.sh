#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR

yum install epel-release -y
yum -y install supervisor autossh dmidecode

cp -rf files/* /

systemctl enable supervisord

cd -
