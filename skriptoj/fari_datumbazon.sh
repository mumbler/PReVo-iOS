#!/bin/sh

laborejo=tmp
konstruilo="build/PoshReVo/Build/Products/Release/DatumbazKonstruilo"

if [ $# -gt 1 ]
then
    laborejo=$1
fi

revejo=$laborejo/xml
perilejo=$laborejo/periloj

echo ""
echo "== Faras perilojn"
mkdir -p $perilejo
bundle exec ruby DatumoPreparilo/datumopreparilo.rb $revejo $perilejo

echo ""
echo "== Faras datumbazon"
$konstruilo $perilejo $laborejo


