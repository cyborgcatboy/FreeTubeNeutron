#!/bin/sh
# freetube pwa from freetubeCordova
# have nuetron config.json
# build neutron
# host pwa on localhost server
# build neutron for localhost server 
export SDIR="$(pwd)"

export FTCVER="0.19.2.110"
export CDYVER="2.7.6"
export CDYARC="linux_amd64"

wget "https://github.com/MarmadileManteater/FreeTubeCordova/releases/download/${FTCVER}/freetube-${FTCVER}-pwa.zip" -O freetube-pwa.zip

rm -r freetube-pwa
unzip freetube-pwa.zip -d freetube-pwa

# if the neutron dir already exists, just git pull inside it, otherwise clone
if [[ -e neutron ]]; then
  cd neutron
  git pull
  cd ..
else
  git clone https://github.com/gamingdoom/neutron --recurse-submodules -j8
fi

cp src/config.json neutron/config.json

cd neutron/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
if ! [[ -e build/config.json ]]; then 
  python configurator.py -c config.json 
fi
cd build
python build.py

cd ${SDIR}/freetube-pwa
if command -v caddy &> /dev/null; then
  # use system caddy to run http server
  echo "caddy found! using..."
  caddy file-server -r . -l :21999
else
  echo "no caddy! downloading binary..."
  wget "https://github.com/caddyserver/caddy/releases/download/v${CDYVER}/caddy_${CDYVER}_${CDYARC}.tar.gz" -O caddy.tar.gz;
  tar -zxf caddy.tar.gz caddy; 
  ./caddy file-server -r . -l :21999  
fi

#bundle exe files with wrapper script that runs localserver command and nuetron build simultainously
