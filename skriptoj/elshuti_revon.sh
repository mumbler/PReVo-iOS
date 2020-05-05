bazaDestino="tmp/xml"

if [ $# -gt 1 ]
then
    bazaDestino=$1
fi

# Pretigi destinan dosierujon
mkdir -p $bazaDestino

# Elshuti voko-grundon
grundoZipNomo="master.zip"
grundoURL="https://github.com/revuloj/voko-grundo/archive/$grundoZipNomo"
grundoRadiko="voko-grundo-master/cfg"
grundoDosieroj="$grundoRadiko/lingvoj.xml $grundoRadiko/literoj.xml $grundoRadiko/stiloj.xml $grundoRadiko/mallongigoj.xml $grundoRadiko/fakoj.xml"
grundoDestino="$bazaDestino/grundo"

mkdir $grundoDestino

echo ""
echo "== Elshutas grundo-dosierojn"
curl -LO $grundoURL

echo ""
echo "== Malpakas grundo-dosierojn"
unzip -j $grundoZipNomo $grundoDosieroj -d $grundoDestino

rm $grundoZipNomo

# Elshuti revon
revoZipNomo="master.zip"
revoURL="https://github.com/revuloj/revo-fonto/archive/$revoZipNomo"
revoRadiko="revo-fonto-master/revo"
revoDosieroj="$revoRadiko/*"
revoDestino="$bazaDestino/revo"

mkdir $revoDestino

echo ""
echo "== Elshutas revo-dosierojn"
curl -LO $revoURL

echo ""
echo "== Malpakas revo-dosierojn"
unzip -j $revoZipNomo $revoDosieroj -d $revoDestino

rm $revoZipNomo
