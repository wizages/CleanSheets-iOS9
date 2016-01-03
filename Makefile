include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CleanSheets9
CleanSheets9_FILES = tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

CleanSheets9_FRAMEWORKS= UIKIT
CleanSheets9_EXTRA_FRAMEWORKS += Cephei
SHARED_CFLAGS = -fobjc-arc

SUBPROJECTS += cleansheets
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall SpringBoard"
