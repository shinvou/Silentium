GO_EASY_ON_ME = 1

TARGET = iphone:clang:latest:8.0
ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SilentiumFlipswitch
SilentiumFlipswitch_FILES = SilentiumFlipswitch.xm
SilentiumFlipswitch_FRAMEWORKS = UIKit
SilentiumFlipswitch_LIBRARIES = flipswitch
SilentiumFlipswitch_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
