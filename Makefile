FW_URL		:= https://github.com/raspberrypi/firmware/branches/stable/boot

EFI_BUILD	:= RELEASE
EFI_ARCH	:= AARCH64
EFI_TOOLCHAIN	:= GCC5
EFI_TIMEOUT	:= 3
EFI_FLAGS	:= --pcd=PcdPlatformBootTimeOut=$(EFI_TIMEOUT) --pcd=PcdRamLimitTo3GB=0 --pcd=PcdRamMoreThan3GB=1
EFI_DSC		:= edk2-platforms/Platform/RaspberryPi/RPi4/RPi4.dsc
EFI_FD		:= Build/RPi4/$(EFI_BUILD)_$(EFI_TOOLCHAIN)/FV/RPI_EFI.fd

IPXE_CROSS	:= aarch64-linux-gnu-
IPXE_SRC	:= ipxe/src
IPXE_TGT	:= bin-arm64-efi/snp.efi
IPXE_EFI	:= $(IPXE_SRC)/$(IPXE_TGT)
IPXE_CONSOLE    := $(IPXE_SRC)/config/local/console.h

all : tftpboot.zip

submodules :
	git submodule update --init --recursive

firmware :
	if [ ! -e firmware ] ; then \
		$(RM) -rf firmware-tmp ; \
		svn export $(FW_URL) firmware-tmp && \
		mv firmware-tmp firmware ; \
	fi

efi : $(EFI_FD)

efi-basetools : submodules
	$(MAKE) -C edk2/BaseTools

$(EFI_FD) : submodules efi-basetools
	. ./edksetup.sh && \
	build -b $(EFI_BUILD) -a $(EFI_ARCH) -t $(EFI_TOOLCHAIN) \
		-p $(EFI_DSC) $(EFI_FLAGS)

$(IPXE_CONSOLE) : submodules
	echo "#define	CONSOLE_SYSLOG" > $@

ipxe : $(IPXE_CONSOLE) $(IPXE_EFI)

$(IPXE_EFI) : submodules
	$(MAKE) -C $(IPXE_SRC) CROSS=$(IPXE_CROSS) CONFIG=rpi $(IPXE_TGT)

pxe : firmware efi ipxe
	$(RM) -rf pxe
	mkdir -p pxe
	cp -r $(sort $(filter-out firmware/kernel%,$(wildcard firmware/*))) \
		pxe/
	cp config.txt $(EFI_FD) edk2/License.txt pxe/
	mkdir -p pxe/efi/boot
	cp $(IPXE_EFI) pxe/efi/boot/bootaa64.efi
	cp ipxe/COPYING* pxe/

tftpboot.zip : pxe
	$(RM) -f $@
	( pushd $< ; zip -q -r ../$@ * ; popd )

update:
	git submodule foreach git pull origin master

tag :
	git tag v`git show -s --format='%ad' --date=short | tr -d -`

.PHONY : submodules firmware efi efi-basetools $(EFI_FD) ipxe $(IPXE_EFI) pxe

clean :
	$(RM) -rf firmware Build pxe tftpboot.zip
	if [ -d $(IPXE_SRC) ] ; then $(MAKE) -C $(IPXE_SRC) clean ; fi
