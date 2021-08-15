#!/usr/bin/env sh

if [ $# -ne 1 ]; then
  echo "download_arm64.sh release"
  echo " e.g. download_arm64.sh 13.0"
  exit
fi

REL=$1
BASE="https://download.freebsd.org/ftp/releases/"

# download arm64 first
ARCH=arm64
for d in base-dbg base doc kernel-dbg kernel src
do
  echo "fetch ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz"
  FILE=${d}.txz
  if [ ! -e ${FILE} ]; then
    fetch ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz
  else
    echo "${FILE} exits"
  fi
done

# then download amd64
ARCH=amd64
for d in base-dbg base 
do
  FILE=${ARCH}_${d}.txz
  echo "fetch -o ${FILE} ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz"
  if [ ! -e ${FILE} ]; then
    fetch -o ${FILE} ${BASE}${ARCH}/${REL}-RELEASE/${d}.txz
  else
    echo "${FILE} exits"
  fi
done

