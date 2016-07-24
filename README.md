# gpio_sh
BASH script to provide a nice interface to CHIP's gpio pins.

## License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

Copyright 2016 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/): 
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/gpio_sh/tree/gh-pages

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.

## Introduction

The [C.H.I.P.](http://getchip.com/) single-board computer has General Purpose
Input/Output pins (GPIOs) which can be accessed with software via the "sysfs"
virtual file system.  The method of identifying specific GPIO pins is not
mnemonic; e.g. one simply has to remember that the pin known as "CSID0" has the
number 132 associated with it.  Even worse, as changes are made to the device
tree, the numeric value associated with a GPIO pin can (and has) changed.  For
example, under CHIPOS 4.3, the GPIO known as "XIO-P0" was associated with
number 408.  Under CHIPOS 4.4, "XIO-P0" changed to 1016.  There is reason to
believe that it will change again in the not-too-distant future.

This project's shell script, "gpio.sh", allows specifying GPIO by name instead
of number.  It derives the correct numbers at run-time for different versions
of the device table, which allows it to work correctly across different
versions of CHIPOS.  It also provides a set of access methods (shell functions)
which slightly simplifies the shell coding.

You can find gpio_sh on github.  See:

* User documentation (this README): https://github.com/fordsfords/gpio_sh/tree/gh-pages

Note: the "gh-pages" branch is considered to be the current stable release.  The "master" branch is the development cutting edge.

## Quick Start

These instructions assume you are in a shell prompt on CHIP.

1. Get the shell script file onto CHIP:

        sudo wget -O /usr/local/bin/gpio.sh http://fordsfords.github.io/gpio_sh/gpio.sh

2. Get and run the example script:

        wget http://fordsfords.github.io/gpio_sh/gpio_example.sh
        chmod +x gpio_example.sh
        sudo ./gpio_example.sh

3. It can also be used for interactive work:

        source /usr/local/bin/gpio.sh
        gpio_export $XIO_P0
        gpio_direction $XIO_P0 in
        gpio_input $XIO_P0; VAL=$?
        echo $VAL
        gpio_unexport $XIO_P0

## API Notes

* Since accessing GPIO pins requires root access, the calling script should
typically be run with "sudo".  For example:

        sudo ./gpio_example.sh

* The gpio.sh script must be sourced so that the shell variables defined will be
available to the caller.

* The symbolic names for GPIOs are the same as are shown in the CHIP
documentation's [Physical
Connectors](http://docs.getchip.com/chip.html#physical-connectors) section
(scroll down to the "Pin Headers" sub-section), except that all dashes ("-")
should be entered as underscores ("_").  When gpio.sh is sourced, it defines
a set of shell variables with the same names as the GPIO names.  For example,
the $XIO_P7 substitutes the proper numeric value.

* When passing a GPIO identifier to a method, you can either pass the shell
variable substitution, which is just the numeric value, or you can pass the
GPIO name as a string.  All three of the following lines export CSID0:

        gpio_export CSID0
        gpio_export $CSID0
        gpio_export 132    # not recommended.

* Many pins on CHIP's pin headers are *not* GPIOs.  For example, GND and VCC-5V
cannot be accessed with software.  The list of symbols defined by gpio.sh
is: PWM0 AP_EINT3 TWI1_SCK TWI1_SDA TWI2_SCK TWI2_SDA LCD_D2 LCD_D3 LCD_D4 LCD_D5 LCD_D6 LCD_D7 LCD_D10 LCD_D11 LCD_D12 LCD_D13 LCD_D14 LCD_D15 LCD_D18 LCD_D19 LCD_D20 LCD_D21 LCD_D22 LCD_D23 LCD_CLK LCD_DE LCD_HSYNC LCD_VSYNC CSIPCK CSICK CSIHSYNC CSIVSYNC CSID0 CSID1 CSID2 CSID3 CSID4 CSID5 CSID6 CSID7 AP_EINT1 UART1_TX UART1_RX XIO_P0 XIO_P1 XIO_P2 XIO_P3 XIO_P4 XIO_P5 XIO_P6 XIO_P7

The available gpio methods are:
* **gpio_export** *gpio* - open a GPIO pin for use.
* **gpio_direction** *gpio* *in/out* - set the GPIO pin for use as an input or output.
* **gpio_output** *gpio* *0/1* - for GPIO pin set to output, set its output
value.
* **gpio_input** *gpio* - for GPIO pin set to input *or* output, read back its
value.  It is made available to the caller via its return status "$?".
Remember that the return status variable is ephemeral, so it is strongly
suggested to copy its value into a regular shell variable.  For example:

        gpio_input XIO_P0; VAL=$?

* **gpio_unexport** *gpio* - close the GPIO pin.
* **gpio_unexport_all** - close ALL opened GPIO pins.  ***WARNING:*** this is
potentially disruptive.  It does NOT restrict itself to only those pins opened
by the currenly running script.  It checks for *ALL* opened (exported) GPIOs
and closes them.  If you are running other software which accesses GPIOs, using
"gpio_unexport_all" will disrupt the operation of that other software.

## Release Notes

* 23-Jul-2016

    * Added ability to pass the GPIO name without the $.
    * Added extra error checking.
    * Added version number (release date) to gpio.sh file

* 30-Jun-2016

    Initial release
