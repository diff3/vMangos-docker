#!/bin/sh

cd /opt/server/bin/tools

mkdir -p /opt/server/data

AD_RES=''
VMAPS_RES=''

if [ $HI_RES = 'YES' ]; then
    AD_RES='-f 0'
    VMAPS_RES='-l'
fi

if [ $MAPS = 'ON' ]; then  
   echo "Extracting: camera, dbc and maps"
   ./ad $AD_RES -i '/opt/wow' -o /opt/server/data
fi

if [ $VMAPS = 'ON' ];  then  
  echo "Extracting: vmaps"
  mkdir /opt/server/data/vmaps
  ./vmap_extractor $VMAPS_RES -d '/opt/wow' -o /opt/server/data

  echo "Assambling: vmaps"
  ./vmap_assembler /opt/server/data/Buildings /opt/server/data/vmaps
fi

if [ $MMAPS = 'ON' ];  then  
  echo "EXTRACTING: mmaps"
  mkdir /opt/server/data/mmaps
  ./MoveMapGen --workdir /opt/server/data --buildGameObjects
fi

rm -r /opt/server/data/Buildings
