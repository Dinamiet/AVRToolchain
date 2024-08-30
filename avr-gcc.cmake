##########################################################################
# Executables in use
##########################################################################
find_program(AVR_CC avr-gcc REQUIRED)
find_program(AVR_CXX avr-g++ REQUIRED)
find_program(AVR_OBJCOPY avr-objcopy REQUIRED)
find_program(AVR_SIZE_TOOL avr-size REQUIRED)
find_program(AVR_OBJDUMP avr-objdump REQUIRED)
find_program(AVR_UPLOADTOOL avrdude REQUIRED)


##########################################################################
# Define CMake System
##########################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
# set(CMAKE_C_COMPILER ${AVR_CC})
# set(CMAKE_CXX_COMPILER ${AVR_CXX})

function(avr_configure MCU_NAME CPU_SPEED)
	add_compile_options(
		"-mmcu=${MCU_NAME}"
	)

	add_compile_definitions(
		"F_CPU=${CPU_SPEED}"
	)

	add_link_options(
		"-mmcu=${MCU_NAME}"
	)

endfunction()

function(avr_upload TARGET MCU_NAME)
	add_custom_target(
		${TARGET}_Upload
		COMMAND
			${AVR_UPLOADTOOL} -l upload.log -p ${MCU_NAME} -c avrftdi -U flash:w:${TARGET} -v
		COMMAND
			${AVR_SIZE_TOOL} -C;--mcu=${MCU_NAME} ${TARGET} #| grep -vE "\"^\\(|^$$\""
		DEPENDS ${TARGET}
		COMMENT "Upload"
	)
endfunction()
