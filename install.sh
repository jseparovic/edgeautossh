#!/bin/bash -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR

yum install epel-release -y
yum -y install autossh dmidecode

cp -rf files/* /

systemctl enable autosshwrap

cd -
