include include/uboot-mali.inc

PROVIDES += "u-boot"

FILESEXTRAPATHS_prepend:= "${THISDIR}/${PN}:"

SRC_URI = " \
	git://github.com/hardkernel/u-boot.git;protocol=git;branch=${SRCBRANCH} \
	file://boot-linux.cmd \
"
SRCBRANCH = "odroidxu3-v2012.07"
SRCREV = "d80b05d5624ecba99c15ee2a7b3f59ebf6f8f1e8"

COMPATIBLE_MACHINE = "(odroidxu3)"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb"

S = "${WORKDIR}/git"

do_deploy () {
	install -d ${DEPLOYDIR}
	install ${S}/${UBOOT_BINARY} ${DEPLOYDIR}/${UBOOT_IMAGE}

	cd ${DEPLOYDIR}
	rm -f ${UBOOT_BINARY} ${UBOOT_SYMLINK}
	ln -sf ${UBOOT_IMAGE} ${UBOOT_SYMLINK}
	ln -sf ${UBOOT_IMAGE} ${UBOOT_BINARY}

	${S}/tools/mkimage -T script -C none -d ${S}/../boot-linux.cmd ${S}/boot.scr

	install ${S}/sd_fuse/hardkernel/bl1.bin.hardkernel ${DEPLOYDIR}/bl1.bin.hardkernel
	install ${S}/sd_fuse/hardkernel/bl2.bin.hardkernel ${DEPLOYDIR}/bl2.bin.hardkernel
	install ${S}/sd_fuse/hardkernel/tzsw.bin.hardkernel ${DEPLOYDIR}/tzsw.bin.hardkernel
	install ${S}/boot.scr ${DEPLOYDIR}/boot.scr
}
