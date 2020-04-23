#!/bin/sh

defaulta_produktajhejo="tmp/produktajhoj"
produktajhejo=$defaulta_produktajhejo

if [ $# -gt 1 ]
then
    produktajhejo=$1
fi

cp $produktajhejo/PoshReVoDatumbazo.sqlite PoshReVo/Helpajhoj/Datumbazo/
cp $produktajhejo/Generataj.strings PoshReVo/Helpajhoj/Base.lproj/
