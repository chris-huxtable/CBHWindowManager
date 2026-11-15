# Standard Xcode actions for the CBHWindowManager scheme.
# Build uses Debug unless CONFIGURATION is set. Test uses Debug. Archive uses Release.

PROJECT       := CBHWindowManager.xcodeproj
SCHEME        := CBHWindowManager
CONFIGURATION ?= Debug

BUILD_DIR     := build
DERIVED_DATA  := $(BUILD_DIR)/DerivedData
ARCHIVE_PATH  := $(BUILD_DIR)/$(SCHEME).xcarchive
FRAMEWORK     := $(BUILD_DIR)/$(SCHEME).framework

# xcodebuild lives in a full Xcode. If xcode-select points at the Command Line
# Tools, use Xcode.app without changing the system selection.
ifeq ($(notdir $(shell xcode-select -p 2>/dev/null)),CommandLineTools)
  XCODE_APP := $(firstword $(wildcard /Applications/Xcode.app /Applications/Xcode-*.app))
  ifneq ($(XCODE_APP),)
    export DEVELOPER_DIR := $(XCODE_APP)/Contents/Developer
  endif
endif

XCODEBUILD    := xcodebuild

.DEFAULT_GOAL := build

.PHONY: build test archive clean xcode

xcode:
	open $(PROJECT)

build:
	$(XCODEBUILD) build \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination 'platform=macOS' \
		-derivedDataPath $(DERIVED_DATA)

test:
	$(XCODEBUILD) test \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		-destination 'platform=macOS' \
		-derivedDataPath $(DERIVED_DATA)

archive:
	mkdir -p $(BUILD_DIR)
	$(XCODEBUILD) archive \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Release \
		-destination 'generic/platform=macOS' \
		-archivePath $(ARCHIVE_PATH) \
		-derivedDataPath $(DERIVED_DATA) \
		SKIP_INSTALL=NO
	rm -rf $(FRAMEWORK)
	ditto $(ARCHIVE_PATH)/Products/Library/Frameworks/$(SCHEME).framework $(FRAMEWORK)

clean:
	$(XCODEBUILD) clean \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-derivedDataPath $(DERIVED_DATA)
	rm -rf $(BUILD_DIR)
