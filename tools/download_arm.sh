#!/usr/bin/env sh

if [ $# -ne 1 ]; then
  echo "download_arm.sh release"
  echo " e.g. download_arm.sh 13.0"
  exit
fi

REL=$1
BASE="https://download.freebsd.org/ftp/releases/"

# download source file
ARCH=amd64
for d in src doc
do
  echo "fetch ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz"
  FILE=${d}.txz
  if [ ! -e ${FILE} ]; then
    fetch ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz
  else
    echo "${FILE} exists"
  fi
done

# next img file
FILE=FreeBSD-${REL}-RELEASE-arm-armv7-GENERICSD.img
if [ ! -e ${FILE} ]; then
  if [ ! -e ${FILE}.xz ]; then
    fetch ${BASE}/arm/armv7/ISO-IMAGES/${REL}/${FILE}.xz
  fi
  unxz ${FILE}.xz
else
  echo "${FILE} exists"
fi

# then download amd64
ARCH=amd64
for d in base-dbg base 
do
  FILE=${ARCH}_${d}.txz
  echo "fetch -o ${FILE} ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz"
  if [ ! -e ${FILE} ]; then
    fetch -o ${FILE} ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz
  else
    echo "${FILE} exists"
  fi
done

