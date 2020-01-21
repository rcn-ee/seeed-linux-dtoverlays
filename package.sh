#!/bin/bash -e

ARCH=$(uname -m)

if [ "x${ARCH}" = "xarmv7l" ] ; then
	uname_r="VERSION"
	distro="DISTRO"
	dpkg_arch="armhf"
else
	uname_r="4.14.58-ti-r65"
	distro="stretch"
	dpkg_arch="amd64"
fi

package="ti-cmem"
base_dir="./"

if [ -f ${base_dir}/src/src/cmem/module/cmemk.ko ] ; then

	#modules
	cp -v ${base_dir}/src/src/cmem/module/cmemk.ko ${base_dir}

	#readme
	cp -v ${base_dir}/src/src/cmem/README ${base_dir}

	echo "Section: misc" > ${base_dir}control
	echo "Priority: optional" >> ${base_dir}control
	echo "Homepage: https://github.com/rcn-ee/${package}" >> ${base_dir}control
	echo "Standards-Version: 3.9.6" >> ${base_dir}control
	echo "" >> ${base_dir}control
	echo "Package: ${package}-modules-${uname_r}" >> ${base_dir}control
	echo "Version: 1${distro}" >> ${base_dir}control
	echo "Pre-Depends: linux-image-${uname_r}" >> ${base_dir}control
	echo "Depends: linux-image-${uname_r}" >> ${base_dir}control
	echo "Maintainer: Robert Nelson <robertcnelson@gmail.com>" >> ${base_dir}control
	echo "Architecture: ${dpkg_arch}" >> ${base_dir}control
	echo "Readme: README" >> ${base_dir}control
	echo "Files: cmemk.ko /lib/modules/${uname_r}/extra/${device}/" >> ${base_dir}control
	echo "Description: ${package} modules" >> ${base_dir}control
	echo " Kernel modules for ${package} devices" >> ${base_dir}control
	echo "" >> ${base_dir}control

	equivs-build control

	rm -rf cmemk.ko || true
	rm -rf README || true
	rm -rf control || true

fi
