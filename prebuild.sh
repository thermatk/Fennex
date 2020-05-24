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

# fix cleaning errors
sed -i -e 's/raise MissingFileError(/self.logger.log(logging.INFO, "IGNORED: "+/g' python/mach/mach/main.py

# clean scanerrors
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
sed -i -e 's/,"tests\/[^:]*:"[^"]*"//g' third_party/rust/rust_cascade/.cargo-checksum.json
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
