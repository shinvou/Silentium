GO_EASY_ON_ME = 1

TARGET = iphone:clang:latest:8.0
ARCHS = armv7 arm64

THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
THEOS_PACKAGE_DIR_NAME = deb

include theos/makefiles/common.mk

TWEAK_NAME = Silentium
Silentium_FILES = Tweak.xm
Silentium_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += SilentiumFlipswitch
SUBPROJECTS += SilentiumSettings

include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_Store" -delete
after-install::
	install.exec "killall -9 backboardd"
