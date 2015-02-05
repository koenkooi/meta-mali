inherit image_types

IMAGE_DEPENDS_sdcard = "parted-native:do_populate_sysroot \
                        dosfstools-native:do_populate_sysroot \
                        mtools-native:do_populate_sysroot \
                        virtual/kernel:do_deploy \
                        u-boot:do_deploy"

SDCARD = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.sdcard"

SDCARD_GENERATION_COMMAND_odroidxu3 = "generate_odroidxu3_sdcard"

BOOT_PART_START = "4096"
FILE_PART_START = "16384"

IMAGE_CMD_sdcard () {
	if [ -z "${SDCARD_ROOTFS}" ]; then
		bberror "SDCARD_ROOTFS is undefined."
		exit 1
	fi

	${SDCARD_GENERATION_COMMAND}
}

generate_odroidxu3_sdcard () {
	dd if=/dev/zero of=${SDCARD} bs=1M count=20

	parted -s ${SDCARD} mktable msdos
	parted -s ${SDCARD} unit KiB mkpart primary ${BOOT_PART_START} ${FILE_PART_START}

	# Create boot partition image
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 1024 }')
	mkfs.vfat -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin ::/${KERNEL_IMAGETYPE}
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${KERNEL_DEVICETREE} ::/${KERNEL_DEVICETREE}
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/boot.scr ::/boot.scr

	dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel of=${SDCARD} conv=notrunc seek=1
	dd if=${DEPLOY_DIR_IMAGE}/bl2.bin.hardkernel of=${SDCARD} conv=notrunc seek=31
	dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX} of=${SDCARD} conv=notrunc seek=63
	dd if=${DEPLOY_DIR_IMAGE}/tzsw.bin.hardkernel of=${SDCARD} conv=notrunc seek=719

	dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc seek=1 bs=$(expr ${BOOT_PART_START} \* 1024) && sync && sync
	dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc seek=1 bs=$(expr ${FILE_PART_START} \* 1024) && sync && sync

	parted -s ${SDCARD} unit KiB mkpart primary ${FILE_PART_START} 100%
}

IMAGE_TYPEDEP_sdcard = "${@d.getVar('SDCARD_ROOTFS', 1).split('.')[-1]}"
