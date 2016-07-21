#!/bin/bash
# By Francesco "dfirfpi" Picasso <francesco.picasso@gmail.com>
#-------------------------------------------------------------------
# Section Variables

TOL='regripper'
SRC='https://github.com/keydet89/RegRipper2.8.git'
DST='/wbin/win/registry/regripper'
LOG="${TOL}.log"

echo "Installing $TOL" > ${LOG}

#-------------------------------------------------------------------
# Requirements (perl assumed in)

sudo perl -MCPAN -e "install Parse::Win32Registry" >> ${LOG} 2>&1

#-------------------------------------------------------------------
# RegRipper installation, patches and configuration

if [ -d ${DST} ]; then
    echo "git updating $TOL"
    git -C ${DST} fetch origin >> ${LOG} 2>&1 || { echo "git fetch of $TOL failed" ; exit 1; }
    git -C ${DST} reset --hard origin/master >> ${LOG} 2>&1 || { echo "git reset of $TOL failed" ; exit 1; }
else
    echo "git cloning $TOL"
    git clone ${SRC} ${DST} >> ${LOG} 2>&1 || { echo "git clone of $TOL failed" ; exit 1; }
fi

dos2unix -ascii ${DST}/* >> ${LOG} 2>&1

sed -i '1 s| c:\\perl\\bin\\perl.exe|/bin/perl|g' ${DST}/rip.pl

chmod 775 ${DST}/rip.pl
chmod -R 755 ${DST}/plugins

if [ ! -L /wbin/rip.pl ]; then
    ln -s ${DST}/rip.pl /wbin/rip.pl
fi

echo "$TOL installed and configured"
