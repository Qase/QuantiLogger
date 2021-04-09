# This export fixes an issues with the latest Xcode beta.
export XCODE_XCCONFIG_FILE=$PWD/tmp.xcconfig
carthage update --platform iOS --no-use-binaries --cache-builds
