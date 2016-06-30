#!/bin/bash
# gpio_example.sh - demonstration of correct use of gpio.sh

source /usr/local/bin/gpio.sh

gpio_export $XIO_P0

gpio_direction $XIO_P0 in

gpio_input $XIO_P0
VAL=$?  # The pin value is returned as status.
echo "XIO_P0 = $VAL"

# Since the value is returned as status, the gpio_input method can be
# tested in a conditional (if, while).  Be aware that the inputted
# value of 0 represents "success" or "true", which some will find
# counter-intuitive.

if gpio_input $XIO_P0
then
  echo "XIO_P0 is 0"
else
  echo "XIO_P0 is 1"
fi

gpio_export $XIO_P1

gpio_direction $XIO_P1 out

gpio_output $XIO_P1 0
gpio_output $XIO_P1 1

# "Copy" P0's value to P1.
gpio_input $XIO_P0; VAL=$?
gpio_output $XIO_P1 $VAL

# At this point, you could unexport each pin individually:
#   gpio_unexport $XIO_P0
#   gpio_unexport $XIO_P1
# Instead, let's just unexport EVERYTHING that might be exported.
# Note: this might be disruptive if other processes are using
# other GPIO pins for their own purposes.
gpio_unexport_all

