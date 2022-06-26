# sync rom
repo init --depth=1 --no-repo-verify -u repo init -u https://github.com/Fusion-OS/android_manifest -b twelve -g default,-mips,-darwin,-notdefault
git clone https://github.com/Orion-Kernel/local_manifest.git --depth 1 -b fuse .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

#3

# build rom
source build/envsetup.sh
export SELINUX_IGNORE_NEVERALLOWS=true
lunch fuse_beryllium-userdebug
export TZ=Asia/Delhi
export BUILD_HOSTNAME=Gaurav #put before last build command
make fuse-prod

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
