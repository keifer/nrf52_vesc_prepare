#!/bin/bash

NRF52_VESC_GITHUB="https://github.com/vedderb/nrf52_vesc"
NRF52_VESC_DIR=`basename "$NRF52_VESC_GITHUB"`
UART_TX_PIN=8
UART_RX_PIN=6
LED_PIN=9

echo "### Download vedderb / nrf52_vesc"
git clone "$NRF52_VESC_GITHUB"
echo "Done"

echo "### Modify UART_TX definition"
sed -i "s/^\(#define UART_TX\s*\)[0-9]\+/\1$UART_TX_PIN/" "$NRF52_VESC_DIR"/main.c
if [ ! "$?" == "0" ]; then
    echo "Modify UART_TX failed, abort"
    exit 1
fi
echo "Done"

echo "### Modify UART_RX definition"
sed -i "s/^\(#define UART_RX\s*\)[0-9]\+/\1$UART_RX_PIN/" "$NRF52_VESC_DIR"/main.c
if [ ! "$?" == "0" ]; then
    echo "Modify UART_RX failed, abort"
    exit 1
fi
echo "Done"

echo "### Modify LED_PIN definition"
sed -i "s/^\(#define LED_PIN\s*\)[0-9]\+/\1$LED_PIN/" "$NRF52_VESC_DIR"/main.c
if [ ! "$?" == "0" ]; then
    echo "Modify LED_PIN failed, abort"
    exit 1
fi
echo "Done"

echo "### Compile nrf52_vesc"
cd "$NRF52_VESC_DIR"
make -j4
if [ ! "$?" == "0" ]; then
    echo "Compile nrf52_vesc fail, abort"
    exit 1
fi
echo "Done"

echo "### upload"
## TODO
