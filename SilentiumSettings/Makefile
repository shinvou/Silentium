ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SilentiumSettings
SilentiumSettings_FILES = SilentiumSettings.mm
SilentiumSettings_INSTALL_PATH = /Library/PreferenceBundles
SilentiumSettings_FRAMEWORKS = UIKit
SilentiumSettings_PRIVATE_FRAMEWORKS = Preferences
SilentiumSettings_LIBRARIES = applist
SilentiumSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SilentiumSettings.plist$(ECHO_END)
