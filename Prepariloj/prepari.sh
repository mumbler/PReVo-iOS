echo "Komencante laboron"
LOKO=$(pwd)
if [ $# -gt 0 ]
then
   LOKO=$1
fi

echo $LOKO/revo
if [ -e $LOKO/revo ]
then

   echo "Trovis elxmligilon kaj revo-dosierujon"
   ruby $LOKO/elxmligilo.rb $LOKO/revo --trace
   echo "Finis elxmligadon"
   if [ ! -e $LOKO/datumoj ]
   then
      echo "Ne trovis datumo-dosierujon"
   fi
   $LOKO/DatumbazKonstruilo
else
   echo "Ne trovis revo-dosierujon"
fi

echo "Laboro finighis"