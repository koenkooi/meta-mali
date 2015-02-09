require mali-userspace.inc

TYPE = "mali-t62x"

SRC_URI = "${MALI_URI}/${PV}-${PR}/${TYPE}_${PV}-${PR}_linux_1+fbdev.tar.gz;name=fbdev \
	 ${MALI_URI}/${PV}-${PR}/${TYPE}_${PV}-${PR}_linux_1+x11.tar.gz;name=x11"

SRC_URI[fbdev.md5sum] = "191076dbbe68b66d41a35cc2b3ba8e8e"
SRC_URI[fbdev.sha256sum] = "6b95d06fd9df5724e21525e845b28f9969ced55b6b4648910dd4393ccadeef93"
SRC_URI[x11.md5sum] = "c5846dada9e3f898deb490527fd6c1b6"
SRC_URI[x11.sha256sum] = "c42f7a2dd9b0b7edcdaac37035706a908cf4eb2cff949355d6c52704daf09831"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://END_USER_LICENCE_AGREEMENT.txt;md5=91ae802bfcae6f13f66c45c069b00cb1"
