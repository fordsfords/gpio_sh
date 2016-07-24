#!/bin/sh
# test.sh - test the gpio.sh file
# Usage: sudo ./test.sh

assert()
{
  eval $1
  R=$?
  if [ $R -ne 0 ]; then :
    echo "assert failed! ('$1')" >&2
    exit 1
  else :
    echo "Passed ('$1')"
  fi
}


source ./gpio.sh

assert "[ $PWM0 -eq 34 ]"
assert "[ $AP_EINT3 -eq 35 ]"
assert "[ $TWI1_SCK -eq 47 ]"
assert "[ $TWI1_SDA -eq 48 ]"
assert "[ $TWI2_SCK -eq 49 ]"
assert "[ $TWI2_SDA -eq 50 ]"
assert "[ $LCD_D2 -eq 98 ]"
assert "[ $LCD_D3 -eq 99 ]"
assert "[ $LCD_D4 -eq 100 ]"
assert "[ $LCD_D5 -eq 101 ]"
assert "[ $LCD_D6 -eq 102 ]"
assert "[ $LCD_D7 -eq 103 ]"
assert "[ $LCD_D10 -eq 106 ]"
assert "[ $LCD_D11 -eq 107 ]"
assert "[ $LCD_D12 -eq 108 ]"
assert "[ $LCD_D13 -eq 109 ]"
assert "[ $LCD_D14 -eq 110 ]"
assert "[ $LCD_D15 -eq 111 ]"
assert "[ $LCD_D18 -eq 114 ]"
assert "[ $LCD_D19 -eq 115 ]"
assert "[ $LCD_D20 -eq 116 ]"
assert "[ $LCD_D21 -eq 117 ]"
assert "[ $LCD_D22 -eq 118 ]"
assert "[ $LCD_D23 -eq 119 ]"
assert "[ $LCD_CLK -eq 120 ]"
assert "[ $LCD_DE -eq 121 ]"
assert "[ $LCD_HSYNC -eq 122 ]"
assert "[ $LCD_VSYNC -eq 123 ]"
assert "[ $CSIPCK -eq 128 ]"
assert "[ $CSICK -eq 129 ]"
assert "[ $CSIHSYNC -eq 130 ]"
assert "[ $CSIVSYNC -eq 131 ]"
assert "[ $CSID0 -eq 132 ]"
assert "[ $CSID1 -eq 133 ]"
assert "[ $CSID2 -eq 134 ]"
assert "[ $CSID3 -eq 135 ]"
assert "[ $CSID4 -eq 136 ]"
assert "[ $CSID5 -eq 137 ]"
assert "[ $CSID6 -eq 138 ]"
assert "[ $CSID7 -eq 139 ]"
assert "[ $AP_EINT1 -eq 193 ]"
assert "[ $UART1_TX -eq 195 ]"
assert "[ $UART1_RX -eq 196 ]"
assert "[ $XIO_P0 -eq $XIO_BASE ]"
assert "[ $XIO_P1 -eq $((XIO_BASE + 1)) ]"
assert "[ $XIO_P2 -eq $((XIO_BASE + 2)) ]"
assert "[ $XIO_P3 -eq $((XIO_BASE + 3)) ]"
assert "[ $XIO_P4 -eq $((XIO_BASE + 4)) ]"
assert "[ $XIO_P5 -eq $((XIO_BASE + 5)) ]"
assert "[ $XIO_P6 -eq $((XIO_BASE + 6)) ]"
assert "[ $XIO_P7 -eq $((XIO_BASE + 7)) ]"

if [ -d "/sys/class/gpio/gpio132" ]; then :
  echo "test.sh: ERROR, CSID0 (gpio132) already exported" >&2
  exit 1
fi

gpio_export CSID0
S=$?; assert "[ $S -eq 0 ]"
assert "[ -d /sys/class/gpio/gpio132 ]"

gpio_direction CSID0 in
S=$?; assert "[ $S -eq 0 ]"
D=`cat /sys/class/gpio/gpio132/direction`
assert "[ $D = in ]"

# This one will fail because you can't output to an input pin
O=`gpio_output CSID0 0 2>&1`
S=$?; assert "[ $S -ne 0 ]"
echo $O | egrep "Operation not permitted" >/dev/null
S=$?; assert "[ $S -eq 0 ]"

gpio_direction CSID0 out
S=$?; assert "[ $S -eq 0 ]"
D=`cat /sys/class/gpio/gpio132/direction`
assert "[ $D = out ]"

gpio_output CSID0 0
S=$?; assert "[ $S -eq 0 ]"
V=`cat /sys/class/gpio/gpio132/value`
assert "[ $V = 0 ]"
gpio_input CSID0; V=$?
assert "[ $V = 0 ]"

gpio_output CSID0 1
S=$?; assert "[ $S -eq 0 ]"
V=`cat /sys/class/gpio/gpio132/value`
assert "[ $V = 1 ]"
gpio_input CSID0; V=$?
assert "[ $V = 1 ]"

gpio_unexport $CSID0
S=$?; assert "[ $S -eq 0 ]"
assert "[ ! -d /sys/class/gpio/gpio132 ]"
