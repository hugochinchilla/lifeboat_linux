build: clean prepare
	./04_build.sh

prepare:
	./01_get.sh
	./02_chrootandinstall.sh
	./03_conf.sh

clean:
	rm -rf build/alpine-minirootfs*
	rm -rf build/linux*

test:
	./05_run_on_kvm.sh
