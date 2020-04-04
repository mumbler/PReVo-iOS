#!/bin/sh

defaulta_revoloko="revo"
revoloko=$defaulta_revoloko

if [ $# -gt 1 ]
then
    revoloko=$1
fi

mkdir tmp

ruby DatumoPreparilo/datumopreparilo.rb $revoloko tmp/revo
./build/PoshReVo/Build/Products/Debug/DatumbazKonstruilo tmp/datumoj tmp


