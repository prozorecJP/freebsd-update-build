#!/usr/bin/env sh

if [ $# -ne 2 ]; then
  echo "crate_iso_arm.sh RELASE original-IMG"
  echo " e.g. create_iso_arm.sh 13.0 FreeBSDxxx.img"
  exit
fi

REL=$1
IMG=$2
ARCH="arm"
ISO="FreeBSD-${REL}-RELEASE-${ARCH}-dvd1.iso"
DIR="iso"
ORIG="org"
MISC=/tmp/_misc.exclude
BASE=/tmp/list

if [ ! -d ${DIR} ]; then
  mkdir ${DIR}
fi

MD=`sudo mdconfig -a -f ${IMG}`
if [ ! -d ${ORIG} ]; then
  mkdir ${ORIG}
fi
sudo mount /dev/${MD}s2a ${ORIG}

rm -f ${ISO}
mkdir -p ${DIR}/usr/freebsd-dist/
cd ${ORIG}
sudo find . -print > ${BASE}

cat > ${MISC} <<EOF
^\./home
^\./boot/loader.conf
^\./boot/msdos
^\./etc/fstab
^\./etc/rc.conf
^\./etc/devd.conf
^\./etc/passwd
^\./etc/master.passwd
^\./etc/group
^\./etc/pwd.db
^\./firstboot
^\./var/mail/freebsd
^\./usr/tests/
^\./usr/lib/debug/
EOF

egrep "^\./boot/(dtb|kernel)" ${BASE} > /tmp/kernel.list
egrep "^\./usr/lib/debug/boot/kernel/.*debug$" ${BASE} > /tmp/kernel-dbg.list
egrep "^\./usr/lib/debug/(bin|lib|libexec|sbin|usr)/.*debug$" ${BASE} > /tmp/base-dbg.list
fgrep -v -f /tmp/kernel.list ${BASE} | fgrep -v -f /tmp/kernel-dbg.list | fgrep -v -f /tmp/base-dbg.list | egrep -v -f ${MISC} > /tmp/base.list

rm -f ${MISC}

sudo -- sh -c "for i in base base-dbg kernel kernel-dbg
do
  tar -ncJf ../${DIR}/usr/freebsd-dist/\${i}.txz -T /tmp/\${i}.list
done"

cd ..
sudo umount /dev/${MD}s2a
sudo mdconfig -d -u ${MD}

for f in *txz
do
  cp ${f} ${DIR}/usr/freebsd-dist/${f}
done

makefs -t cd9660 -o rockridge ${ISO} ${DIR}


if [ -e ${ISO} ]; then
   rmdir ${ORIG}
   rm -fr ${DIR}
   rm -f /tmp/list /tmp/base.list /tmp/base-dbg.list /tmp/kernel.list /tmp/kernel-dbg.list
fi

