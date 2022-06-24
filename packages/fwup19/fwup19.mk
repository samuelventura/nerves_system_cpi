################################################################################
#
# fwup
#
################################################################################

FWUP19_VERSION = 1.9.0
FWUP19_SITE = $(call github,fwup-home,fwup,v$(FWUP19_VERSION))
FWUP19_LICENSE = Apache-2.0
FWUP19_LICENSE_FILES = LICENSE
FWUP19_DEPENDENCIES = host-pkgconf libconfuse libarchive
HOST_FWUP19_DEPENDENCIES = host-pkgconf host-libconfuse host-libarchive
FWUP19_AUTORECONF = YES
FWUP19_CONF_ENV = ac_cv_path_HELP2MAN=""

$(eval $(autotools-package))
$(eval $(host-autotools-package))
