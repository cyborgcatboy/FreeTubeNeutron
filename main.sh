#!/bin/sh
# freetube pwa from freetubeCordova
# have nuetron config.json
# build neutron
# host pwa on localhost server
# build neutron for localhost server 

export FTCVER="0.19.2.110"

wget https://github.com/MarmadileManteater/FreeTubeCordova/releases/download/${FTCVER}/freetube-${FTCVER}-pwa.zip 

unzip freetube-${FTCVER}-pwa -o -d freetube-pwa

git clone https://github.com/gamingdoom/neutron --recurse-submodules -j8

cp config.json neutron/config.json

cd neutron/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python configurator.py -c config.json 
cd build
python build.py

#bundle exe files with wrapper script that runs localserver command and nuetron build simultainously
