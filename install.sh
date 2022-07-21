#!/bin/bash -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR

yum install epel-release -y
yum -y install autossh dmidecode

easy_install-3.6 pip
pip3 install git+https://github.com/jseparovic/supervisor.git@maxbackoff

cp -rf files/* /

systemctl enable supervisord

cd -
