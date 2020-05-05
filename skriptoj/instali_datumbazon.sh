#!/bin/sh

produktajhejo="tmp/produktajhoj"

if [ $# -gt 1 ]
then
    produktajhejo=$1
fi

echo ""
echo "== Instalas datumbazon"
cp $produktajhejo/PoshReVoDatumbazo.sqlite PoshReVo/Helpajhoj/Datumbazo/

echo ""
echo "== Instalas tekstojn"
cp $produktajhejo/Generataj.strings PoshReVo/Helpajhoj/Base.lproj/
