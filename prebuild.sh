#!/bin/bash
# Based on https://gitlab.com/Manizuca/fenneclocales/

REPO=$( echo $( cd `dirname $0`; pwd ) )

# copy config
cp -f $REPO/.mozconfig ./

# include gradle in config
echo "ac_add_options --with-gradle=$(which gradle)" >> .mozconfig

# remove elfhack
sed -i -e 's/default=default_elfhack/default=False/g' toolkit/moz.configure

# GMP
sed -i -e '/gmp-provider/d' mobile/android/app/mobile.js
echo 'pref("media.gmp-provider.enabled", false);' >> mobile/android/app/mobile.js
echo 'pref("media.gmp-manager.url.override", "data:text/plain,");' >> mobile/android/app/mobile.js
sed -i -e '/gmp-gmpopenh264.enabled/d' mobile/android/app/mobile.js
sed -i -e '/gmp-gmpopenh264.visible/d' mobile/android/app/mobile.js
echo 'pref("media.gmp-gmpopenh264.enabled", false);' >> mobile/android/app/mobile.js

# healthreport
sed -i -e "s/HEALTHREPORT\', True/HEALTHREPORT\', False/g" mobile/android/moz.configure

# crashreporter
sed -i -e '/crashreporter/d' Cargo.toml

# Fix Gradle for fdroid
sed -i -e '/.variant.name}AndroidTest/d' mobile/android/gradle.configure

# 1/2 fix cleaning errors
sed -i -e 's/raise MissingFileError(/self.logger.log(logging.INFO, "IGNORED: "+/g' python/mach/mach/main.py

# 2/2 ugly way to fix errors after cleaning
sed -i -e '/testing\/talos/d' toolkit/toolkit.mozbuild
sed -i -e '/test\/mochitest/d' -e '/test\/unit\/xpcshell/d' modules/libjar/moz.build
sed -i -e '/test\/unit\/xpcshell/d' toolkit/components/mediasniffer/moz.build
sed -i -e '/tests\/xpcshell/d' -e '/tests\/SearchTestUtils/d' toolkit/components/search/moz.build
sed -i -e '/tests\/unit\/xpcshell/d' -e '/unit\/TelemetryArchiveTesting.jsm/d' toolkit/components/telemetry/moz.build
rm mobile/android/geckoview/src/androidTest/assets/moz.build
sed -i -e '/src\/androidTest\/assets/d' mobile/android/moz.build
sed -i -e '/xpcshellTestRoot.der/d' security/apps/moz.build
sed -i -e '/tests\/mochitest.ini/d' dom/file/moz.build
sed -i -e '/test\/forms\/mochitest.ini/d' -e '/test\/mochitest.ini/d' -e '/test\/forms\/chrome.ini/d' -e '/test\/chrome.ini/d' -e '/test\/browser.ini/d' dom/html/moz.build
sed -i -e '/identity\/mochitest.ini/d' -e '/test\/mochitest.ini/d' dom/media/moz.build
sed -i -e '/test\/mochitest.ini/d' dom/media/mediasource/moz.build dom/workers/moz.build dom/serviceworkers/moz.build
sed -i -e '/test\/browser.ini/d' dom/workers/moz.build
sed -i -e '/tests\/mochitest.ini/d' -e '/tests\/browser.ini/d' dom/xhr/moz.build
sed -i -e '/crashtest\/crashtests.list/d' -e '/reftests/d' layout/moz.build
sed -i -e '/test\/unit_ipc\/xpcshell/d' -e '/test\/unit\/xpcshell/d' -e '/mochitest.ini/d' -e '/test\/chrome/d' -e '/test\/navigation/d' -e '/test\/browser/d' docshell/moz.build
sed -i -e '/test\/mochitest/d' toolkit/components/extensions/moz.build
sed -i -e '/addons-mlbf.bin/d' services/settings/dumps/blocklists/moz.build

# actual cleaning
rm -R third_party/rust/winapi-*-pc-windows-gnu/lib/*.a
rm -R tools/update-packaging/test/
rm -R third_party/rust/miniz_oxide/tests/
sed -i -e 's/,"tests\/[^:]*:"[^"]*"//g' third_party/rust/miniz_oxide/.cargo-checksum.json
rm -R third_party/rust/sha2/tests/
sed -i -e 's/,"tests\/[^:]*:"[^"]*"//g' third_party/rust/sha2/.cargo-checksum.json
rm -R third_party/python/pipenv/pipenv/patched/notpip/_vendor/distlib/*.exe
rm -R third_party/python/pipenv/pipenv/vendor/pip9/_vendor/distlib/*.exe
rm -R modules/libmar/tests/
rm -R config/tests/test.manifest.jar
rm -R third_party/rust/sha-1/tests/
sed -i -e 's/,"tests\/[^:]*:"[^"]*"//g' third_party/rust/sha-1/.cargo-checksum.json
rm -R third_party/rust/deflate/tests/
sed -i -e 's/,"tests\/[^:]*:"[^"]*"//g' third_party/rust/deflate/.cargo-checksum.json
rm -R third_party/rust/rust_cascade/test_data/
sed -i -e 's/,"tests\/[^:]*:"[^"]*"//g' -e 's/,"test_data\/[^:]*:"[^"]*"//g' third_party/rust/rust_cascade/.cargo-checksum.json
rm -R modules/libjar/test/
rm -R toolkit/mozapps/extensions/test/
rm -R toolkit/mozapps/update/tests/
rm -R toolkit/components/telemetry/tests/search/
rm -R toolkit/components/telemetry/tests/unit/
rm -R toolkit/components/mediasniffer/test/unit/
rm -R toolkit/components/reputationservice/test/unit/data/signed_win.exe
rm -R toolkit/components/search/tests/
rm -R toolkit/components/crashes/tests/
rm -R toolkit/crashreporter/test/unit/
rm -R toolkit/crashreporter/breakpad-client/mac/handler/testcases/
rm -R toolkit/crashreporter/google-breakpad/src/tools/windows/
rm -R testing/raptor/raptor/profiler/dump_syms_mac
rm -R testing/web-platform/
rm -R testing/talos/talos/
rm -R docshell/test/
rm services/settings/dumps/blocklists/addons-bloomfilters/addons-mlbf.bin
rm devtools/client/debugger/packages/devtools-wasm-dwarf/wasm/dwarf_to_json.wasm
rm -R devtools/client/debugger/test/
rm -R security/nss/cmd/bltest/tests/
rm -R security/nss/cmd/samples/
rm -R security/nss/tests/
rm -R security/manager/ssl/tests/
rm -R security/manager/ssl/osclientcerts/test/
rm -R media/webrtc/trunk/webrtc/test/
rm -R intl/icu/source/test/testdata/
rm -R layout/reftests/
rm -R other-licenses/nsis/nsisui.exe
rm -R other-licenses/7zstub/src/bin
rm -R build/pymake/tests/
rm -R dom/html/test/
rm -R dom/security/test/
rm -R dom/tests/
rm -R dom/xhr/tests/
rm -R dom/base/test/
rm -R dom/media/test/
rm -R dom/media/mediasource/test/
rm -R xpcom/tests/
rm -R browser/branding/*/dsstore
rm -R browser/components/migration/tests/unit/
rm -R netwerk/test/unit/data/signed_win.exe
