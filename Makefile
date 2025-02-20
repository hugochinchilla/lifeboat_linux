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
build: clean prepare configure
	./05_build.sh

.PHONY: clean
clean:
	rm -rf build/alpine-minirootfs*
	rm -rf build/linux*

.PHONY: test
test:
	./10_run_on_kvm.sh
