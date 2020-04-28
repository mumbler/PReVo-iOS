#!/bin/sh

defaulta_revoloko="DatumoPreparilo/revo"
revoloko=$defaulta_revoloko

if [ $# -gt 1 ]
then
    revoloko=$1
fi

mkdir tmp

bundle exec ruby DatumoPreparilo/datumopreparilo.rb $revoloko tmp
./build/PoshReVo/Build/Products/Debug/DatumbazKonstruilo tmp/datumoj tmp


