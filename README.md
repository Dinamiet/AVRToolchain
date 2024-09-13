# Toolchains

## AVR
Toolchain for AVR CPUs is available in `avr-gcc.cmake`.
It can be used by `include()`ing it in another project/CMake file.

It automatically searches for the avr-gcc toolchain to compile and build for AVR microcontrollers.

To configure a project for a specific microcontroller the following CMake function needs to be called:
>	avr_project_configure(MCU CLOCK)

It will add the required compile options, compile definitions and link options to all subsequent defined targets (add_executable, add_library) for compiling and building.

To create a custom upload target of the executable binary, the following function may be used:
>	avr_upload_target(TARGET MCU)

This will create a Upload target that will attempt to program the controller though an the ICSP interface using an FTDI device.


`TARGET` specifies the executable target. The function will automatically create an extra build target with a `Upload`  prefix which will program the binary to the target board using an FTDI programmer though ICSP pins.

`MCU` The core which is build for, eg atmega328p

`CLOCK` The system clock speed of the controller, required to determine clock scaling factor registers
