# Fennex
Rebuilding Fenix

## Geckoview to local Maven repo

### Checkout source
```
hg clone --uncompressed https://hg.mozilla.org/releases/mozilla-release/
cd mozilla-release
hg up FIREFOX_76_0_1_RELEASE
cd ..
git clone https://github.com/rust-lang/rustup
cd rustup
git checkout 1.21.1
cd ..
```
### Pre-Build
```
export NDK=/opt/android-sdk/ndk/20.1.5948944
export ANDROID_HOME=/opt/android-sdk
cd mozilla-release
sed -i -e '/crashreporter/d' Cargo.toml
echo "ac_add_options --enable-application=mobile/android" >> .mozconfig
echo "ac_add_options --enable-linker=lld" >> .mozconfig
echo "ac_add_options --disable-tests" >> .mozconfig
echo "ac_add_options --disable-debug" >> .mozconfig
echo "ac_add_options --disable-nodejs" >> .mozconfig
echo "ac_add_options --disable-updater" >> .mozconfig
echo "ac_add_options --disable-crashreporter" >> .mozconfig
echo "ac_add_options --with-branding=mobile/android/branding/unofficial" >> .mozconfig
echo "export MOZ_INSTALL_TRACKING=" >> .mozconfig
echo "export MOZ_NATIVE_DEVICES=" >> .mozconfig
echo "ac_add_options --with-gradle=$(which gradle5)" >> .mozconfig
sed -i -e 's/raise MissingFileError(/self.logger.log(logging.INFO, "IGNORED: "+/g' python/mach/mach/main.py
sed -i -e "s/HEALTHREPORT\', True/HEALTHREPORT\', False/g" mobile/android/moz.configure
rm -R third_party/rust/winapi-*-pc-windows-gnu/lib/*.a
sed -i -e '/.variant.name}AndroidTest/d' mobile/android/gradle.configure
sed -i -e '/gmp-provider/d' mobile/android/app/mobile.js
echo 'pref("media.gmp-provider.enabled", false);' >> mobile/android/app/mobile.js
echo 'pref("media.gmp-manager.url.override", "data:text/plain,");' >> mobile/android/app/mobile.js
sed -i -e '/gmp-gmpopenh264.enabled/d' mobile/android/app/mobile.js
sed -i -e '/gmp-gmpopenh264.visible/d' mobile/android/app/mobile.js
echo 'pref("media.gmp-gmpopenh264.enabled", false);' >> mobile/android/app/mobile.js
sed -i -e 's/default=default_elfhack/default=False/g' toolkit/moz.configure
sed -i -e 's/r20/r20b/g' python/mozboot/mozboot/android.py
echo "ac_add_options --target=aarch64-linux-android" >> .mozconfig
echo "ac_add_options --with-android-min-sdk=21" >> .mozconfig
echo "ac_add_options --with-android-ndk=\"$NDK\"" >> .mozconfig
echo "ac_add_options --with-android-sdk=\"$ANDROID_HOME\"" >> .mozconfig
echo "ac_add_options --enable-application=mobile/android" >> .mozconfig
echo "ac_add_options --with-branding=mobile/android/branding/unofficial" >> .mozconfig
echo "ac_add_options --with-libclang-path=$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib64/" >> .mozconfig
echo "mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj" >> .mozconfig
pushd mobile/android/branding/unofficial/
sed -i -e '/ANDROID_PACKAGE_NAME/d' -e '/MOZ_APP_DISPLAYNAME/d' configure.sh
echo 'ANDROID_PACKAGE_NAME=org.mozilla.fennec_fdroid' >> configure.sh
echo 'MOZ_APP_DISPLAYNAME="Fennec F-Droid"' >> configure.sh
echo 'MOZ_APP_ANDROID_VERSION_CODE=760120' >> configure.sh
sed -i -e 's/Mozilla Fennec/Fennec F-Droid/g' locales/en-US/brand*
popd
../rustup/rustup-init.sh -y
source $HOME/.cargo/env
rustup default 1.43.1
rustup target add aarch64-linux-android
cargo install --force --vers 0.14.2 cbindgen
```
### Build
```
./mach build
gradle publishWithGeckoBinariesReleasePublicationToMavenLocal
```
# Credits
* [Fennec F-Droid](https://gitlab.com/fdroid/fdroiddata/blob/master/metadata/org.mozilla.fennec_fdroid.yml) and its [FennecLocales subproject](https://gitlab.com/Manizuca/fenneclocales)
* [Mozilla](https://github.com/mozilla-mobile) :)
