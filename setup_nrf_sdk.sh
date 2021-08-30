#!/bin/bash -x

NRF_SDK_URL="https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs/nRF5/Binaries/nRF5SDK153059ac345.zip"
NRF_SDK_UNZIP_DIR="nRF5_SDK_15.3.0_59ac345"
NRF_MAKEFILE_POSIX="$NRF_SDK_UNZIP_DIR/components/toolchain/gcc/Makefile.posix"
GNU_INSTALL_ROOT="/usr/bin/"

echo "### Download NRF SDK"
curl "$NRF_SDK_URL" > `basename "$NRF_SDK_URL"`
if [ ! "$?" == "0" ]; then
    echo "Download NRF SDK failed, abort"
    exit 1
fi

echo "### Unzip NRF SDK"
unzip -q `basename "$NRF_SDK_URL"`
echo "Done"

echo "### Modify GCC Path"
ESC_GNU_INSTALL_ROOT=${GNU_INSTALL_ROOT////\\/}
sed -i "/GNU_INSTALL_ROOT/s/?= .*/?= $ESC_GNU_INSTALL_ROOT/" "$NRF_MAKEFILE_POSIX"
if [ ! "$?" == "0" ]; then
    echo "Modify GCC patch failed, abort"
    exit 1
fi
echo "Done"
