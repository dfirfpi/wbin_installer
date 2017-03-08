#!/bin/bash
# By Francesco "dfirfpi" Picasso <francesco.picasso@gmail.com>
#
# First create "/wbin" folder and chown to the user.
# Then git clone in "/wbin" the project
# chmod +x install/install_all
#
# Note: NOT using repo https://forensics.cert.org/
#       "manual" approach means that a small subset of libs and
#       tools will be downloaded from "my" repos and installed
#
#-------------------------------------------------------------------

TUXREL="fc24"
LOG="wbin_install.log"
ROOT_FOLDER="/wbin"
INS_FOLDER="$ROOT_FOLDER/install"

[ -d ${ROOT_FOLDER} ] || { echo "wbin folder does not exist!"; exit 1; }
[ -d ${INS_FOLDER} ] || { echo "wbin/install folder does not exist!"; exit 1; }

ARC_FOLDER="$ROOT_FOLDER/archive"
WIN_FOLDER="$ROOT_FOLDER/win"

#-------------------------------------------------------------------
# Function

function install_libyal {

    LIB_NAME=$1
    LIB_VERSION=$2

    SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"

    wget -nv -nc "${SOURCE}/${LIB_NAME}-${LIB_VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
    if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${LIB_NAME} ${LIB_VERSION}"; fi
    wget -nv -nc "${SOURCE}/${LIB_NAME}-tools-${LIB_VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
    if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${LIB_NAME} ${LIB_VERSION} tools"; fi
    wget -nv -nc "${SOURCE}/${LIB_NAME}-python-${LIB_VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
    if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${LIB_NAME} ${LIB_VERSION} python2"; fi
    wget -nv -nc "${SOURCE}/${LIB_NAME}-python3-${LIB_VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
    if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${LIB_NAME} ${LIB_VERSION} python3 libs"; fi
    sudo dnf -y install ${ARC_FOLDER}/${LIB_NAME}-*.rpm >> ${LOG} 2>&1
}

#-------------------------------------------------------------------

echo "Starting DFIRFPI tools installation [manual]" > ${LOG}

# 1st level folders
[ -d ${ARC_FOLDER} ] || mkdir ${ARC_FOLDER}
[ -d ${WIN_FOLDER} ] || mkdir ${WIN_FOLDER}

NTFS_FOLDER="$WIN_FOLDER/ntfs"
REG_FOLDER="$WIN_FOLDER/registry"
SHB_FOLDER="$WIN_FOLDER/shellbags"
USB_FOLDER="$WIN_FOLDER/usb"

# 1st level Windows folder
[ -d ${NTFS_FOLDER} ] || mkdir ${NTFS_FOLDER}
[ -d ${REG_FOLDER} ] || mkdir ${REG_FOLDER}
[ -d ${SHB_FOLDER} ] || mkdir ${SHB_FOLDER}
[ -d ${USB_FOLDER} ] || mkdir ${USB_FOLDER}

#-------------------------------------------------------------------
# Requirements

sudo dnf -y install perl-CPAN >> ${LOG} 2>&1
sudo dnf -y install python python-pip python-setuptools >> ${LOG} 2>&1
sudo dnf -y install python3 python3-pip python3-setuptools >> ${LOG} 2>&1
sudo dnf -y install openssl-libs openssl fuse fuse-python >> ${LOG} 2>&1
sudo dnf -y install yara python2-yara python3-yara >> ${LOG} 2>&1
sudo dnf -y reinstall python3-pip >> ${LOG} 2>&1

sudo pip install --upgrade pip >> ${LOG} 2>&1
sudo pip3 install --upgrade pip >> ${LOG} 2>&1

# SleuthKit section -----------------------------
sudo dnf -y install afflib afftools >> ${LOG} 2>&1

install_libyal "libewf" "20160424-1"

TSK_VER="4.3.1-1"
wget -nv -nc "https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64/sleuthkit-${TSK_VER}.${TUXREL}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "unable to download sleuthkit"; exit 1; fi
sudo dnf -y install ${ARC_FOLDER}/sleuthkit-*.rpm >> ${LOG} 2>&1

NAME="python-pytsk3"
VERSION="20161109-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

NAME="python3-pytsk3"
VERSION="20161109-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

# Plaso section ---------------------------------

sudo dnf install -y python-dateutil python3-dateutil python-dpkt >> ${LOG} 2>&1
sudo dnf install -y python-ipython python3-ipython >> ${LOG} 2>&1
sudo dnf install -y pyparsing python-pefile python-psutil python3-psutil >> ${LOG} 2>&1

sudo pip install artifacts bencode binplist construct==2.5.2 dfdatetime >> ${LOG} 2>&1
sudo pip install hachoir_core hachoir_metadata hachoir_parser >> ${LOG} 2>&1
sudo pip install efilter xlsxwriter >> ${LOG} 2>&1

sudo pip3 install artifacts bencode binplist construct dfdatetime >> ${LOG} 2>&1
sudo pip3 install hachoir_core hachoir_metadata hachoir_parser >> ${LOG} 2>&1
sudo pip3 install efilter xlsxwriter >> ${LOG} 2>&1

install_libyal "libbde"     "20160731-1"
install_libyal "libesedb"   "20160622-1"
install_libyal "libevt"     "20160421-1"
install_libyal "libevtx"    "20170122-1"
install_libyal "libfsntfs"  "20160418-1"
install_libyal "libfvde"    "20160918-1"
install_libyal "libfwnt"    "20161103-1"
install_libyal "libfwsi"    "20160110-1"
install_libyal "liblnk"     "20160420-1"
install_libyal "libmsiecf"  "20160904-1"
install_libyal "libolecf"   "20161113-1"
install_libyal "libqcow"    "20160123-1"
install_libyal "libregf"    "20160424-1"
install_libyal "libscca"    "20170105-1"
install_libyal "libsigscan" "20160312-1"
install_libyal "libsmdev"   "20160320-1"
install_libyal "libsmraw"   "20160424-1"
install_libyal "libvhdi"    "20160424-1"
install_libyal "libvmdk"    "20160119-1"
install_libyal "libvshadow" "20161111-1"
install_libyal "libvslvm"   "20160110-1"

NAME="python-dfwinreg"
VERSION="20160428-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.noarch.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.noarch.rpm >> ${LOG} 2>&1

NAME="python-dfvfs"
VERSION="20160918-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.noarch.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.noarch.rpm >> ${LOG} 2>&1

# NTFS section ----------------------------------

sudo pip install analyzeMFT  >> ${LOG} 2>&1
[ -L ${NTFS_FOLDER}/analyzeMFT.py ] || ln -s /usr/bin/analyzeMFT.py ${NTFS_FOLDER}/analyzeMFT.py

# MISC section ----------------------------------

sudo dnf -y install nano scite testdisk >> ${LOG} 2>&1
sudo dnf -y install dc3dd dd_rescue ddrescue ssdeep >> ${LOG} 2>&1
sudo dnf -y install pycryptopp libpst fuse-encfs >> ${LOG} 2>&1

sudo pip install pycrypto >> ${LOG} 2>&1
sudo pip3 install pycrypto >> ${LOG} 2>&1

NAME="xmount"
VERSION="pre0.7.5-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.${TUXREL}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.${TUXREL}.x86_64.rpm >> ${LOG} 2>&1


#-------------------------------------------------------------------

${INS_FOLDER}/install_regripper.sh
${INS_FOLDER}/install_usbdeviceforensics.sh

#-------------------------------------------------------------------
# TODO

# PyAFF4
# rekall
# volatility
# autopsy (latest)
# bulk-extractor
# shellbags
# usn
#sudo dnf -y install radare radare-extras python-radare bokken >> ${LOG} 2>&1
# snort
# hc tools
# wb tools
