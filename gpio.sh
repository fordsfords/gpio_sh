# gpio.sh - BASH code intended to be "sourced" by user script.

gpio_export()
{
  echo $1 >/sys/class/gpio/export
}

gpio_unexport()
{
  echo $1 >/sys/class/gpio/unexport
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
  echo $2 >/sys/class/gpio/gpio${1}/direction
}

gpio_output()
{
  echo $2 >/sys/class/gpio/gpio${1}/value
}

gpio_input()
{
  VAL=`cat /sys/class/gpio/gpio${1}/value`
  return $VAL
}

export PWM0=34
export AP_EINT3=35
export TWI1_SCK=47
export TWI1_SDA=48
export TWI2_SCK=49
export TWI2_SDA=50
export LCD_D2=98
export LCD_D3=99
export LCD_D4=100
export LCD_D5=101
export LCD_D6=102
export LCD_D7=103
export LCD_D10=106
export LCD_D11=107
export LCD_D12=108
export LCD_D13=109
export LCD_D14=110
export LCD_D15=111
export LCD_D18=114
export LCD_D19=115
export LCD_D20=116
export LCD_D21=117
export LCD_D22=118
export LCD_D23=119
export LCD_CLK=120
export LCD_DE=121
export LCD_HSYNC=122
export LCD_VSYNC=123
export CSIPCK=128
export CSICK=129
export CSIHSYNC=130
export CSIVSYNC=131
export CSID0=132
export CSID1=133
export CSID2=134
export CSID3=135
export CSID4=136
export CSID5=137
export CSID6=138
export CSID7=139
export AP_EINT1=193
export UART1_TX=195
export UART1_RX=196

# The XIO pins change their base number across different versions of CHIPOS.
# Derive the correct base number.
XIO_LABEL_FILE=`grep -l pcf8574a /sys/class/gpio/*/*label`
XIO_BASE_FILE=`dirname $XIO_LABEL_FILE`/base
XIO_BASE=`cat $XIO_BASE_FILE`
export XIO_P0=$XIO_BASE
export XIO_P1=$((XIO_BASE + 1))
export XIO_P2=$((XIO_BASE + 2))
export XIO_P3=$((XIO_BASE + 3))
export XIO_P4=$((XIO_BASE + 4))
export XIO_P5=$((XIO_BASE + 5))
export XIO_P6=$((XIO_BASE + 6))
export XIO_P7=$((XIO_BASE + 7))
