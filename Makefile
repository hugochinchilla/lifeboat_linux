.DEFAULT_GOAL := build

.PHONY: prepare
prepare:
	./01_get.sh
	./02_chrootandinstall.sh
	./03_alpine_config.sh

.PHONY: configure
configure:
	./04_kernel_config.sh

.PHONY: menuconfig
menuconfig:
	cd build/linux && make nconfig

.PHONY: build
build: prepare configure
	./05_build.sh
	$(MAKE) vm/disk.img

.PHONY: clean
clean:
	rm -rf build/alpine-minirootfs*
	rm -rf build/linux*
	rm -f build/config.initramfs_root

.PHONY: test
test: vm/disk.img
	./10_run_on_kvm.sh

vm/disk.img: dist/LifeboatLinux.efi
	rm -f vm/disk.img
	mkdir -p vm/tmp/EFI/BOOT
	cp dist/LifeboatLinux.efi vm/tmp/EFI/BOOT/bootx64.efi
	virt-make-fs --format=raw --partition=gpt --type=vfat --label=ESP vm/tmp vm/disk.img
