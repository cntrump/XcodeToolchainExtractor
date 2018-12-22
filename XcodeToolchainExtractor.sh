#!/bin/bash

set -e

xcode_version=$1
xcode_pkg="Xcode_${xcode_version}.xip"

if [ ! -f "${xcode_pkg}" ];
then
	echo not found "${xcode_pkg}"
	exit -1
fi

xip -x "${xcode_pkg}"

if [ ! -d Toolchains ];
then
	mkdir Toolchains
fi

xcode_toolchain_output="Toolchains/Xcode${xcode_version}.xctoolchain"

mv Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain ${xcode_toolchain_output}

toolchain_info="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>DisplayName</key>
	<string>Xcode ${xcode_version}</string>
	<key>CFBundleIdentifier</key>
	<string>com.apple.dt.toolchain.XcodeDefault.${xcode_version}</string>
</dict>
</plist>"

echo ${toolchain_info} > Toolchains/Xcode${xcode_version}.xctoolchain/ToolchainInfo.plist
echo done, toolchain saved as ${xcode_toolchain_output}

echo cleanup Xcode.app ...
rm -rf Xcode.app

echo all done.

exit 0
