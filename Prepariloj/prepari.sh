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
   if [ -e $LOKO/preparita ]
   then
      mv $LOKO/preparita $LOKO/PReVo/Datumoj
   else
      echo "Ne trovis preparitan dosierujon"
   fi
else
   echo "Ne trovis revo-dosierujon"
fi

echo "Laboro finighis"