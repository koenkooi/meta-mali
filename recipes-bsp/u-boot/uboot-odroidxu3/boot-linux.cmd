setenv bootargs root=/dev/mmcblk1p2 rw rootwait console=ttySAC2,115200n8 consoleblank=0
setenv bootcmd "fatload mmc 0:1 40008000 zImage; fatload mmc 0:1 46000000 exynos5422-odroidxu3.dtb; bootz 40008000 - 46000000"

boot
