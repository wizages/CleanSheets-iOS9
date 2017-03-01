SDKVERSION = 10.1
SYSROOT = $(THEOS)/sdks/iPhoneOS10.1.sdk
SHARED_CFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk


TWEAK_NAME = CleanSheets9
CleanSheets9_FILES = tweak.xm
CleanSheets9_FRAMEWORKS= UIKIT
CleanSheets9_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += cleansheets
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall SpringBoard"
