#!/bin/sh

defaulta_revoloko="DatumoPreparilo/revo"
revoloko=$defaulta_revoloko

konstruilo="build/PoshReVo/Build/Products/Release/DatumbazKonstruilo"

if [ $# -gt 1 ]
then
    revoloko=$1
fi

mkdir tmp

bundle exec ruby DatumoPreparilo/datumopreparilo.rb $revoloko tmp
$konstruilo tmp/datumoj tmp


