# gpio.sh - BASH code intended to be "sourced" by user script.
# Version 23-Jul-2016

gpio_export()
{
  # Accept numeric argument
  if echo "$1" | egrep '^[0-9][0-9]*$' >/dev/null; then :
    GPIO=$1
  elif [ -n "${GPIO_HASH[$1]}" ]; then :
    GPIO=${GPIO_HASH[$1]}
  else :
    echo "gpio_export: unrecognized GPIO ID '$1'" >&2
    return
  fi
  echo $GPIO >/sys/class/gpio/export
  return $?
}

gpio_unexport()
{
  # Accept numeric argument
  if echo "$1" | egrep '^[0-9][0-9]*$' >/dev/null; then :
    GPIO=$1
  elif [ -n "${GPIO_HASH[$1]}" ]; then :
    GPIO=${GPIO_HASH[$1]}
  else :
    echo "gpio_unexport: unrecognized GPIO ID '$1'" >&2
    return
  fi
  echo $GPIO >/sys/class/gpio/unexport
  return $?
}

gpio_unexport_all()
{
  for F in /sys/class/gpio/gpio[0-9]*; do :
    if [ -d "$F" ]; then :
      # strip off all of the path up to the first digit.
      GPIO=`echo $F | sed 's/^[^0-9]*//'`
      echo $GPIO >/sys/class/gpio/unexport
    fi
  done
}

gpio_direction()
{
  # Accept numeric argument
  if echo "$1" | egrep '^[0-9][0-9]*$' >/dev/null; then :
    GPIO=$1
  elif [ -n "${GPIO_HASH[$1]}" ]; then :
    GPIO=${GPIO_HASH[$1]}
  else :
    echo "gpio_direction: unrecognized GPIO ID '$1'" >&2
    return
  fi
  echo $2 >/sys/class/gpio/gpio${GPIO}/direction
  return $?
}

gpio_output()
{
  # Accept numeric argument
  if echo "$1" | egrep '^[0-9][0-9]*$' >/dev/null; then :
    GPIO=$1
  elif [ -n "${GPIO_HASH[$1]}" ]; then :
    GPIO=${GPIO_HASH[$1]}
  else :
    echo "gpio_output: unrecognized GPIO ID '$1'" >&2
    return
  fi
  echo $2 >/sys/class/gpio/gpio${GPIO}/value
  return $?
}

gpio_input()
{
  # Accept numeric argument
  if echo "$1" | egrep '^[0-9][0-9]*$' >/dev/null; then :
    GPIO=$1
  elif [ -n "${GPIO_HASH[$1]}" ]; then :
    GPIO=${GPIO_HASH[$1]}
  else :
    echo "gpio_input: unrecognized GPIO ID '$1'" >&2
    return
  fi
  VAL=`cat /sys/class/gpio/gpio${GPIO}/value`
  return $VAL
}


# Create hash (associative array) for pins
declare -A GPIO_HASH

GPIO_HASH["PWM0"]=34
GPIO_HASH["AP_EINT3"]=35
GPIO_HASH["TWI1_SCK"]=47
GPIO_HASH["TWI1_SDA"]=48
GPIO_HASH["TWI2_SCK"]=49
GPIO_HASH["TWI2_SDA"]=50
GPIO_HASH["LCD_D2"]=98
GPIO_HASH["LCD_D3"]=99
GPIO_HASH["LCD_D4"]=100
GPIO_HASH["LCD_D5"]=101
GPIO_HASH["LCD_D6"]=102
GPIO_HASH["LCD_D7"]=103
GPIO_HASH["LCD_D10"]=106
GPIO_HASH["LCD_D11"]=107
GPIO_HASH["LCD_D12"]=108
GPIO_HASH["LCD_D13"]=109
GPIO_HASH["LCD_D14"]=110
GPIO_HASH["LCD_D15"]=111
GPIO_HASH["LCD_D18"]=114
GPIO_HASH["LCD_D19"]=115
GPIO_HASH["LCD_D20"]=116
GPIO_HASH["LCD_D21"]=117
GPIO_HASH["LCD_D22"]=118
GPIO_HASH["LCD_D23"]=119
GPIO_HASH["LCD_CLK"]=120
GPIO_HASH["LCD_DE"]=121
GPIO_HASH["LCD_HSYNC"]=122
GPIO_HASH["LCD_VSYNC"]=123
GPIO_HASH["CSIPCK"]=128
GPIO_HASH["CSICK"]=129
GPIO_HASH["CSIHSYNC"]=130
GPIO_HASH["CSIVSYNC"]=131
GPIO_HASH["CSID0"]=132
GPIO_HASH["CSID1"]=133
GPIO_HASH["CSID2"]=134
GPIO_HASH["CSID3"]=135
GPIO_HASH["CSID4"]=136
GPIO_HASH["CSID5"]=137
GPIO_HASH["CSID6"]=138
GPIO_HASH["CSID7"]=139
GPIO_HASH["AP_EINT1"]=193
GPIO_HASH["UART1_TX"]=195
GPIO_HASH["UART1_RX"]=196

# The XIO pins change their base number across different versions of CHIPOS.
# Derive the correct base number.
XIO_LABEL_FILE=`grep -l pcf8574a /sys/class/gpio/*/*label`
XIO_BASE_FILE=`dirname $XIO_LABEL_FILE`/base
XIO_BASE=`cat $XIO_BASE_FILE`
GPIO_HASH["XIO_P0"]=$XIO_BASE
GPIO_HASH["XIO_P1"]=$((XIO_BASE + 1))
GPIO_HASH["XIO_P2"]=$((XIO_BASE + 2))
GPIO_HASH["XIO_P3"]=$((XIO_BASE + 3))
GPIO_HASH["XIO_P4"]=$((XIO_BASE + 4))
GPIO_HASH["XIO_P5"]=$((XIO_BASE + 5))
GPIO_HASH["XIO_P6"]=$((XIO_BASE + 6))
GPIO_HASH["XIO_P7"]=$((XIO_BASE + 7))

# Scan the hash and create individual shell variables for each pin
for GPIO in ${!GPIO_HASH[*]}; do :
  eval $GPIO=${GPIO_HASH["$GPIO"]}
done
