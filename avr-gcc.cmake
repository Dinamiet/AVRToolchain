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
# Define CMAKE system
##########################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_CXX_COMPILER ${AVR_CXX})

function(avr_configure PROJECT_NAME MCU_NAME CPU_SPEED)
	set(MCU ${MCU_NAME} CACHE INTERNAL "CPU Type")
	set(CPU_FREQ ${CPU_SPEED} CACHE INTERNAL "CPU Frequency")
	set(ELF ${PROJECT_NAME}.elf CACHE INTERNAL "ELF file name")
	set(HEX ${PROJECT_NAME}.hex CACHE INTERNAL "HEX file name")

	target_compile_options(
		${PROJECT_NAME}
		PRIVATE
			"-mmcu=${MCU}"
	)

	target_compile_definitions(
		${PROJECT_NAME}
		PRIVATE
			"F_CPU=${CPU_FREQ}"
	)

	target_link_options(
		${PROJECT_NAME}
		PRIVATE
			"-mmcu=${MCU}"
			"-Wl,--gc-sections"
	)

	set_target_properties(
		${PROJECT_NAME}
		PROPERTIES
			OUTPUT_NAME ${ELF}
	)

endfunction()

function(avr_upload PROJECT_NAME PORT BAUD)
	add_custom_command(
		OUTPUT ${HEX}
		COMMAND
			${AVR_OBJCOPY} -j .text -j .data -O ihex ${ELF} ${HEX}
		COMMAND
			${AVR_SIZE_TOOL} -C;--mcu=${MCU} ${ELF} | grep -vE "\"^\\(|^$$\""
		DEPENDS ${ELF}
		COMMENT "Uploading"
	)

	add_custom_target(
		upload
		ALL
		COMMAND
			${AVR_UPLOADTOOL} -l upload.log -D -p ${MCU} -c arduino -P ${PORT} -b ${BAUD} -U flash:w:${HEX}
		DEPENDS ${HEX}
		COMMENT "Done"
	)
endfunction()
