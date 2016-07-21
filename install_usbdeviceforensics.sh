#!/bin/bash
# By Francesco "dfirfpi" Picasso <francesco.picasso@gmail.com>
#-------------------------------------------------------------------
# Section Variables

TOL='usbdeviceforensics'
SRC="https://github.com/woanware/$TOL.git"
DST="/wbin/archive/$TOL"
LNK='/wbin/win/usb'
LOG="${TOL}.log"

echo "Installing $TOL" > ${LOG}

#-------------------------------------------------------------------
# Requirements (perl assumed in)

sudo pip install python-registry >> ${LOG} 2>&1

#-------------------------------------------------------------------
# Installation, patches and configuration

if [ -d ${DST} ]; then
    echo "git updating $TOL"
    git -C ${DST} fetch origin >> ${LOG} 2>&1 || { echo "git fetch of $TOL failed" ; exit 1; }
    git -C ${DST} reset --hard origin/master >> ${LOG} 2>&1 || { echo "git reset of $TOL failed" ; exit 1; }
else
    echo "git cloning $TOL"
    git clone ${SRC} ${DST} >> ${LOG} 2>&1 || { echo "git clone of $TOL failed" ; exit 1; }
fi

chmod 775 ${DST}/usbdeviceforensics.py
chmod 775 ${DST}/pyTskusbdeviceforensics.py

[ -L "$LNK/usbdeviceforensics.py" ] || ln -s ${DST}/usbdeviceforensics.py ${LNK}/usbdeviceforensics.py
[ -L "$LNK/pyTskusbdeviceforensics.py" ] || ln -s ${DST}/pyTskusbdeviceforensics.py ${LNK}/pyTskusbdeviceforensics.py

echo "$TOL installed and configured"
