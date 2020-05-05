#!/bin/sh

echo ""
echo "==== Komencas preparadon"

echo ""
echo "==== Elshutas datumojn"
sh skriptoj/elshuti_revon.sh

echo ""
echo "==== Konstruas Datumbazokonstruilon"
sh skriptoj/konstrui_konstruilon.sh

echo ""
echo "==== Faras datumbazon"
sh skriptoj/fari_datumbazon.sh

echo ""
echo "==== Instalas datumbazon"
sh skriptoj/instali_datumbazon.sh

echo ""
echo "==== Preparado finighis"
echo ""
