#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR

yum install epel-release -y
yum -y install supervisor autossh

cp -rf files/* /

systemctl start supervisord
systemctl enable supervisord

cd -
