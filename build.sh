#!/bin/bash

ARCH=$(uname -m)

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	#https://github.com/Seeed-Studio/seeed-linux-dtverlays
	git clone https://github.com/Seeed-Studio/seeed-linux-dtoverlays ./src --depth=1

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		CC=""
		KBUILD=/build/buildd/linux-src
		make_options="CC= KBUILD=/build/buildd/linux-src"
	else
		x86_dir="`pwd`/../../normal"
		if [ -f `pwd`/../../normal/.CC ] ; then
			. `pwd`/../../normal/.CC
			KBUILD=${x86_dir}/KERNEL
			make_options="CC=${CC} KBUILD=${x86_dir}/KERNEL"
		fi
	fi

	SEEED_MODULES=('adxl34x' 'bme280' 'e-ink' 'grove-button' 'grove-led' 'gt9xx' 'hcsr04' 'hd44780' 'lis3lv02d' 'mcp25xxfd' 'mpr121' 'p9813' 'seeed-voicecard' 'sht3x' 'vl53l0x')
	for module in "${SEEED_MODULES[@]}"; 
	do
		echo "Building: $module"
		if [ -f ./src/modules/$module/Makefile ] ; then
			cd ./src/modules/$module/
			make ARCH=arm CROSS_COMPILE=${CC} -C ${KBUILD} M=`pwd` modules
			echo "**********************"
			echo "Files:"
			echo `ls *.ko`
			echo "**********************"
			cd -
		fi
	done

	echo "**********************"
	echo "Modules:"
	find ./src/modules/ | grep .ko | grep -v cmd
	echo "**********************"
fi

#
