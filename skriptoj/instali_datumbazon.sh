#!/bin/sh

produktajhejo="tmp/produktajhoj"
savkopiejo="savkopioj"

if [ $# -gt 1 ]
then
    produktajhejo=$1
fi

if [ $# -gt 2 ]
then
    savkopiejo=$2
fi

datumbaznomo=PoshReVoDatumbazo.sqlite
datumbazejo=PoshReVo/Risurcoj/Datumbazo
tekstarnomo=Generataj.strings
tekstejo=PoshReVo/Risurcoj/Base.lproj/

if [ -e $datumbazejo/$datumbaznomo ] || [ -e $tekstejo/$tekstarnomo ]
then
    echo ""
    echo "== Konservas savkopiojn"
    mkdir -p $savkopiejo

    if [ -e $datumbazejo/$datumbaznomo ]
    then
	cp $datumbazejo/$datumbaznomo $savkopiejo/$datumbaznomo
    fi

    if [ -e $tekstejo/$testarnomo ]
    then
	cp $tekstejo/$tekstarnomo $savkopiejo/$tekstarnomo
    fi
fi

echo ""
echo "== Instalas datumbazon"
cp $produktajhejo/$datumbaznomo $datumbazejo

echo ""
echo "== Instalas tekstojn"
cp $produktajhejo/$tekstarnomo $tekstejo
