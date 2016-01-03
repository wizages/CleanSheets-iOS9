include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CleanSheets9
CleanSheets9_FILES = cleansheetsRootListController.m $(wildcard *.m)
CleanSheets9_INSTALL_PATH = /Library/PreferenceBundles
CleanSheets9_FRAMEWORKS = UIKit Social
CleanSheets9_PRIVATE_FRAMEWORKS = Preferences
CleanSheets9_EXTRA_FRAMEWORKS += CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CleanSheets.plist$(ECHO_END)
