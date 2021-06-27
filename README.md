# Toolchains

## AVR
Toolchain for AVR CPUs is available in `avr-gcc.cmake`

###	Extra functions
>	`avr_configure(` Project `CPU` `SPEED` `)`

`CPU` defines the chip to program for (eg atmega328p).
`SPEED` defines the clock speed of the chip - used by peripherals

>	`avr_upload(` Project `PORT` `BAUD` `)`
`PORT` defines the serial port to use during uploading. `BAUD` specifies the serial port speed to use for uploading.
