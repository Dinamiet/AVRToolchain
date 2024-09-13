# Toolchains

## AVR
Toolchain for AVR CPUs is available in `avr-gcc.cmake`

Automatically searches for the avr-gcc toolchain to compile and build for AVR microcontrollers.

To configure a project for a specific microcontroller the following CMake function needs to be called:
>	target_avr_configure(TARGET CPU CLOCK)

`TARGET` specifies the executable target. The function will automatically create an extra build target with a `Upload`  prefix which will program the binary to the target board using an FTDI programmer though ICSP pins.

`CPU` The core which is build for, eg atmega328p

`CLOCK` The system clock speed of the controller, required to determine clock scaling factor registers
