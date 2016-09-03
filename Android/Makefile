PROGRAM_NAME := Connect4
ANDROID_PLATFORM := android-24

BUILD_DIR := $(PWD)/$(PROGRAM_NAME)-$(QT_PRODUCT)

BUILD_DIR_OBJECT := $(BUILD_DIR)/build
BUILD_DIR_ANDROID := $(BUILD_DIR)/android-build

QT_DIR := $(QT_PATH)/$(QT_PRODUCT)
QMAKE := $(QT_DIR)/bin/qmake
QDEPLOY := $(QT_DIR)/bin/androiddeployqt

JDK_DIR := $(shell readlink -f $$(which java) | sed "s/\/jre.*//")
ANT := /usr/bin/ant

DEPLOY_JSON_NAME := android-lib$(PROGRAM_NAME).so-deployment-settings.json
DEPLOY_JSON_FILE := $(BUILD_DIR_OBJECT)/$(DEPLOY_JSON_NAME)

ANDROID_TOOLS := $(ANDROID_SDK_ROOT)/tools

all: debug

$(ANDROID_TOOLS):
	$(error "Please define ANDROID_SDK_ROOT")

$(QT_DIR):
	$(error "Please define QT_PATH and QT_PRODUCT")

ifeq ($(ANDROID_KEY_FILE),)
ANDROID_KEY_FILE := "/tmp/noway"
endif

$(ANDROID_KEY_FILE):
	$(error "Please create a key and set KEY_FILE and KEY_ALIAS")

$(BUILD_DIR_OBJECT):
	mkdir -p $@

$(BUILD_DIR_OBJECT)/Makefile: $(BUILD_DIR_OBJECT) $(ANDROID_TOOLS)
	$(QMAKE) ../$(PROGRAM_NAME).pro -r -spec android-g++ -o $@

qmake: $(BUILD_DIR_OBJECT)/Makefile

make: qmake
	$(MAKE) -C $(BUILD_DIR_OBJECT)

android-install: make
	$(MAKE) -C $(BUILD_DIR_OBJECT) INSTALL_ROOT=$(BUILD_DIR_ANDROID) install

deploy-qt-debug: android-install
	$(QDEPLOY) --input $(DEPLOY_JSON_FILE) --output $(BUILD_DIR_ANDROID) --deployment bundled --android-platform $(ANDROID_PLATFORM) --jdk $(JDK_DIR) --ant $(ANT)

deploy-qt-release: android-install $(ANDROID_KEY_FILE)
	$(QDEPLOY) --input $(DEPLOY_JSON_FILE) --output $(BUILD_DIR_ANDROID) --deployment bundled --android-platform $(ANDROID_PLATFORM) --jdk $(JDK_DIR) --ant $(ANT) --release --sign $(ANDROID_KEY_FILE) $(ANDROID_KEY_ALIAS)

debug: deploy-qt-debug

release: deploy-qt-release
