#!/bin/bash -xe

# configure system for pypilot if pypilot hat is detected

DEV_FILE=/proc/device-tree/hat/custom_0
PYPILOT=0

if [ -f "$DEV_FILE" ]; then
  if grep -q "mpu" "$DEV_FILE"; then PYPILOT=1; fi
  if grep -q "lcd" "$DEV_FILE"; then PYPILOT=1; fi
  if grep -q "lirc" "$DEV_FILE"; then
    PYPILOT=1
    # enable lirc, config gpio
    if ! grep -q "^dtoverlay=gpio-ir,gpio_pin=4" /boot/config.txt; then
      if grep -q "^dtoverlay=gpio-ir,gpio_pin=" /boot/config.txt; then
        sed -i "s/^dtoverlay=gpio-ir,gpio_pin=.*/dtoverlay=gpio-ir,gpio_pin=4/" /boot/config.txt || true
      else
        echo 'dtoverlay=gpio-ir,gpio_pin=4' >> /boot/config.txt
      fi
    fi
  fi
  if [ "$PYPILOT" = "1" ]; then
    # enable pypilot serial port scan
    sed -i "s_/dev/ttyAMA0__" /home/pypilot/.pypilot/blacklist_serial_ports || true
    # enable UART
    if ! grep -q "^enable_uart=1" /boot/config.txt; then
      if grep -q "^enable_uart=" /boot/config.txt; then
        sed -i "s/^enable_uart=.*/enable_uart=1/" /boot/config.txt || true
      else
        echo 'enable_uart=1' >> /boot/config.txt
      fi
    fi
    # disable bluetooth
    if ! grep -q "^dtoverlay=disable-bt" /boot/config.txt; then
      if grep -q "^dtoverlay=.*able-bt" /boot/config.txt; then
        sed -i "s/^dtoverlay=enable-bt/dtoverlay=disable-bt/" /boot/config.txt || true
      else
        echo 'dtoverlay=disable-bt' >> /boot/config.txt
      fi
    fi
  fi
fi

exit 0
