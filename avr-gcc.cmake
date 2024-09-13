##########################################################################
# Name of target and processor architecture
##########################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

##########################################################################
# Find toolchain binaries
##########################################################################
find_program(CMAKE_CXX_COMPILER "avr-g++" REQUIRED)
find_program(CMAKE_CXX_COMPILER_AR "avr-gcc-ar" REQUIRED)
find_program(CMAKE_CXX_COMPILER_RANLIB "avr-gcc-ranlib" REQUIRED)
find_program(CMAKE_C_COMPILER "avr-gcc" REQUIRED)
find_program(CMAKE_C_COMPILER_AR "avr-gcc-ar" REQUIRED)
find_program(CMAKE_C_COMPILER_RANLIB "avr-gcc-ranlib" REQUIRED)
find_program(CMAKE_PROJECT_SIZE "avr-size" REQUIRED)
find_program(CMAKE_PROJECT_UPLOAD "avrdude" REQUIRED)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

##########################################################################
# Extras
##########################################################################
function(avr_project_configure MCU CLOCK)
	add_compile_options(
			"-mmcu=${MCU}"
	)

	add_compile_definitions(
		"F_CPU=${CLOCK}"
	)

	add_link_options(
		"-mmcu=${MCU}"
	)
endfunction()

function(avr_upload_target TARGET MCU)
	add_custom_command(
		TARGET
			${TARGET}
		POST_BUILD
		COMMAND
			${CMAKE_PROJECT_SIZE} -C;--mcu=${MCU} $<TARGET_FILE:${TARGET}>
	)

	add_custom_target(
		Upload_${TARGET}
		COMMAND
			${CMAKE_PROJECT_UPLOAD} -l upload.log -p ${MCU} -c avrftdi -U flash:w:$<TARGET_FILE:${TARGET}> -v
		DEPENDS
			$<TARGET_FILE:${TARGET}>
		COMMENT
			"Upload"
	)
endfunction()
