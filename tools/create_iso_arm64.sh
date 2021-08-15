#!/usr/bin/env sh

if [ $# -ne 1 ]; then
  echo "crate_iso_arm64.sh RELASE"
  echo " e.g. create_iso_arm64.sh 13.0"
  exit
fi

REL=$1
ARCH="arm64"
ISO="FreeBSD-${REL}-RELEASE-${ARCH}-dvd1.iso"
DIR="iso"

if [ ! -d ${DIR} ]; then
  mkdir ${DIR}
fi

rm -f ${ISO}
mkdir -p ${DIR}/usr/freebsd-dist/
for f in *txz
do
  cp ${f} ${DIR}/usr/freebsd-dist/${f}
done

makefs -t cd9660 -o rockridge ${ISO} ${DIR}

if [ -e ${ISO} ]; then
  rm -fr ${DIR}
fi

