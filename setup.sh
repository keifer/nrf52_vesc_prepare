#!/bin/bash -x

NRF_SDK_URL="https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs/nRF5/Binaries/nRF5SDK1702d674dde.zip"
NRF_SDK_UNZIP_DIR="nRF5_SDK_17.0.2_d674dde"
NRF_MAKEFILE_POSIX="$NRF_SDK_UNZIP_DIR/components/toolchain/gcc/Makefile.posix"
GNU_INSTALL_ROOT="/usr/bin/"

NRF52_VESC_GITHUB="https://github.com/vedderb/nrf52_vesc"
NRF52_VESC_DIR=`basename "$NRF52_VESC_GITHUB"`
UART_TX_PIN=996
UART_RX_PIN=997
LED_PIN=998

echo "### Download NRF SDK"
curl "$NRF_SDK_URL" > `basename "$NRF_SDK_URL"`
if [ ! "$?" == "0" ]; then
    echo "Download NRF SDK failed, abort"
    exit 1
fi

echo "### Unzip NRF SDK"
unzip `basename "$NRF_SDK_URL"`
echo "Done"

echo "### Modify GCC Path"
ESC_GNU_INSTALL_ROOT=${GNU_INSTALL_ROOTT////\\/}
sed -i "/GNU_INSTALL_ROOT/s/?= .*/?= $ESC_GNU_INSTALL_ROOT/" "$NRF_MAKEFILE_POSIX"
if [ ! "$?" == "0" ]; then
    echo "Modify GCC patch failed, abort"
    exit 1
fi
echo "Done"

echo "### Download vedderb / nrf52_vesc"
git clone "$NRF52_VESC_GITHUB"
echo "Done"

echo "### Modify UART_TX definition"
sed -n "s/^\(#define UART_TX\s*\)[0-9]\+/\1$UART_TX_PIN/p" "$NRF52_VESC_DIR"/main.c
if [ ! "$?" == "0" ]; then
    echo "Modify UART_TX failed, abort"
    exit 1
fi
echo "Done"

echo "### Modify UART_RX definition"
sed -n "s/^\(#define UART_RX\s*\)[0-9]\+/\1$UART_RX_PIN/p" "$NRF52_VESC_DIR"/main.c
if [ ! "$?" == "0" ]; then
    echo "Modify UART_RX failed, abort"
    exit 1
fi
echo "Done"

echo "### Modify LED_TX definition"
sed -n "s/^\(#define LED_PIN\s*\)[0-9]\+/\1$LED_PIN/p" "$NRF52_VESC_DIR"/main.c
if [ ! "$?" == "0" ]; then
    echo "Modify LED_PIN failed, abort"
    exit 1
fi
echo "Done"

echo "### Compile nrf52_vesc"
make
if [ ! "$?" == "0" ]; then
    echo "Compile nrf52_vesc fail, abort"
    exit 1
fi
echo "Done"

echo "### upload"
## TODO
