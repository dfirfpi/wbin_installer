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

TUXREL="fc23"
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
    wget -nv -nc "${SOURCE}/${LIB_NAME}-python3-${LIB_VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>$
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

# SleuthKit section -----------------------------
sudo dnf -y install afflib afftools >> ${LOG} 2>&1

install_libyal "libewf" "20160424-1"

TSK_VER="4.3.0-1"
wget -nv -nc "https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/fc23/x86_64/sleuthkit-${TSK_VER}.fc23.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "unable to download sleuthkit"; exit 1; fi
sudo dnf -y install ${ARC_FOLDER}/sleuthkit-*.rpm >> ${LOG} 2>&1

NAME="pytsk3-python"
VERSION="20160721-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

# Plaso section ---------------------------------

sudo dnf install -y python-dateutil python3-dateutil python-dpkt >> ${LOG} 2>&1
sudo dnf install -y python-ipython python3-ipython >> ${LOG} 2>&1
sudo dnf install -y pyparsing python-pefile python-psutil python3-psutil >> ${LOG} 2>&1
sudo dnf install -y yara yara-python >> ${LOG} 2>&1

sudo pip install artifacts bencode binplist construct dfdatetime >> ${LOG} 2>&1
sudo pip install hachoir_core hachoir_metadata hachoir_parser >> ${LOG} 2>&1
sudo pip install efilter xlsxwriter >> ${LOG} 2>&1

install_libyal "libbde"     "20160731-1"
install_libyal "libesedb"   "20160622-1"
install_libyal "libevt"     "20160421-1"
install_libyal "libevtx"    "20160421-1"
install_libyal "libfsntfs"  "20160418-1"
install_libyal "libfvde"    "20160801-1"
install_libyal "libfwsi"    "20160110-1"
install_libyal "liblnk"     "20160420-1"
install_libyal "libmsiecf"  "20160421-1"
install_libyal "libolecf"   "20160423-1"
install_libyal "libqcow"    "20160123-1"
install_libyal "libregf"    "20160424-1"
install_libyal "libscca"    "20160108-1"
install_libyal "libsigscan" "20160312-1"
install_libyal "libsmdev"   "20160320-1"
install_libyal "libsmraw"   "20160424-1"
install_libyal "libvhdi"    "20160424-1"
install_libyal "libvmdk"    "20160119-1"
install_libyal "libvshadow" "20160110-1"

NAME="python-dfwinreg"
VERSION="20160428-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.noarch.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}*.rpm >> ${LOG} 2>&1

NAME="python-dfvfs"
VERSION="20160803-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.noarch.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
if [[ $? != 0 ]]; then echo "[ERROR] unable to download ${NAME} ${VERSION}"; exit; fi
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

NAME="libyara"
VERSION="3.5.0-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

NAME="yara"
VERSION="3.5.0-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

NAME="yara-python"
VERSION="3.5.0-1"
SOURCE="https://github.com/dfirfpi/rpm_bin_dfirfpi/raw/master/${TUXREL}/x86_64"
wget -nv -nc "${SOURCE}/${NAME}-${VERSION}.x86_64.rpm" -P ${ARC_FOLDER} >> ${LOG} 2>&1
sudo dnf -y install ${ARC_FOLDER}/${NAME}-${VERSION}.x86_64.rpm >> ${LOG} 2>&1

exit

# NTFS section ----------------------------------

sudo pip install analyzeMFT  >> ${LOG} 2>&1
[ -L ${NTFS_FOLDER}/analyzeMFT.py ] || ln -s /usr/bin/analyzeMFT.py ${NTFS_FOLDER}/analyzeMFT.py

# RE section ------------------------------------

# MISC section ----------------------------------

sudo dnf -y install dc3dd dd_rescue ddrescue >> ${LOG} 2>&1

#sudo dnf -y install ddrutility dfvfs dff dfwinreg distorm3 >> ${LOG} 2>&1
#sudo dnf -y install eindeutig epub >> ${LOG} 2>&1
#sudo dnf -y install fatback fcrackzip ffmpeg-libs >> ${LOG} 2>&1
#sudo dnf -y install frag_find frag_find-tools fundl >> ${LOG} 2>&1
#sudo dnf -y install ghostpdl guymager >> ${LOG} 2>&1
#sudo dnf -y install hachoir-core hachoir-metadata hachoir-parser hachoir-wx >> ${LOG} 2>&1
#sudo dnf -y install kracked >> ${LOG} 2>&1
#sudo dnf -y install libavdevice >> ${LOG} 2>&1
#sudo dnf -y install libbde libbde-python libbde-tools >> ${LOG} 2>&1
#sudo dnf -y install libbfio >> ${LOG} 2>&1
#sudo dnf -y install libesedb libesedb-python libesedb-tools >> ${LOG} 2>&1
#sudo dnf -y install libevt libevt-python libevt-tools >> ${LOG} 2>&1
#sudo dnf -y install libevtx libevtx-python libevtx-tools >> ${LOG} 2>&1
#sudo dnf -y install libfsntfs libfsntfs-python libfsntfs-tools >> ${LOG} 2>&1
#sudo dnf -y install libfvde libfvde-tools >> ${LOG} 2>&1
#sudo dnf -y install libfwnt libfwnt-python libfwnt-python3 >> ${LOG} 2>&1
#sudo dnf -y install libfwsi libfwsi-python >> ${LOG} 2>&1
#sudo dnf -y install libiconv libiconv-utils >> ${LOG} 2>&1
#sudo dnf -y install liblnk liblnk-python liblnk-tools >> ${LOG} 2>&1
#sudo dnf -y install libluksde libluksde-python libluksde-tools >> ${LOG} 2>&1
#sudo dnf -y install libmsiecf libmsiecf-python libmsiecf-tools >> ${LOG} 2>&1
#sudo dnf -y install libolecf libolecf-python libolecf-tools >> ${LOG} 2>&1
#sudo dnf -y install libpff libpff-python libpff-tools >> ${LOG} 2>&1
#sudo dnf -y install libpst libpst-libs libpst-python >> ${LOG} 2>&1
#sudo dnf -y install libqcow libqcow-python libqcow-tools >> ${LOG} 2>&1
#sudo dnf -y install libregf libregf-python libregf-tools >> ${LOG} 2>&1
#sudo dnf -y install libscca libscca-python libscca-python3 libscca-tools >> ${LOG} 2>&1
#sudo dnf -y install libsigscan libsigscan-python libsigscan-python3 libsigscan-tools >> ${LOG} 2>&1
#sudo dnf -y install libsmdev libsmdev-python libsmdev-python3 libsmdev-tools >> ${LOG} 2>&1
#sudo dnf -y install libsmraw libsmraw-python libsmraw-tools >> ${LOG} 2>&1
#sudo dnf -y install libunrar >> ${LOG} 2>&1
#sudo dnf -y install libvhdi libvhdi-python libvhdi-tools >> ${LOG} 2>&1
#sudo dnf -y install libvmdk libvmdk-python libvmdk-tools >> ${LOG} 2>&1
#sudo dnf -y install libvshadow libvshadow-python libvshadow-tools >> ${LOG} 2>&1
#sudo dnf -y install libvslvm libvslvm-python libvslvm-python3 libvslvm-tools >> ${LOG} 2>&1
#sudo dnf -y install libsmdev libsmdev-python libsmdev-python3 libsmdev-tools >> ${LOG} 2>&1
#sudo dnf -y install log2timeline >> ${LOG} 2>&1
#sudo dnf -y install md5deep md5 missidentify mount_ewf >> ${LOG} 2>&1
#sudo dnf -y install nDPI netsa-python netsa-rayon netsa_silk null-package >> ${LOG} 2>&1
#sudo dnf -y install partclone perl-File-Mork perl-Max-PropertyList >> ${LOG} 2>&1
#sudo dnf -y install perl-Parse-Evtx perl-Parse-Evtx-tools perl-Parse-Win32Registry >> ${LOG} 2>&1
#sudo dnf -y install prism pstotext pyew python-binplist python-construct >> ${LOG} 2>&1
#sudo dnf -y install python-dfdatetime python-rarfile python-registry pytsk >> ${LOG} 2>&1
#sudo dnf -y install rar reglookup rifiuti rifiuti2 >> ${LOG} 2>&1
#sudo dnf -y install scrounge-ntfs sfdumper ssdeep stegdetect >> ${LOG} 2>&1
#sudo dnf -y install snort snort-sample-rules >> ${LOG} 2>&1
#sudo dnf -y install testdisk >> ${LOG} 2>&1
#sudo dnf -y install undbx unrar untex >> ${LOG} 2>&1
#sudo dnf -y install videosnarf >> ${LOG} 2>&1
#sudo dnf -y install xslxwriter xmount xplico >> ${LOG} 2>&1
#sudo dnf -y install yaf yara yara-python >> ${LOG} 2>&1

#sudo dnf -y install plaso >> ${LOG} 2>&1
#sudo dnf -y install radare radare-extras python-radare bokken >> ${LOG} 2>&1

#-------------------------------------------------------------------
# Special, up to date versions

# TODO
# plaso HEAD version install ${INS_FOLDER}/install_plaso.sh
# autopsy (latest)
# bulk-extractor
# shellbags
# usn
# volatility + rekall
# willy...

${INS_FOLDER}/install_regripper.sh
${INS_FOLDER}/install_usbdeviceforensics.sh

#-------------------------------------------------------------------
