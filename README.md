PXE-chainloadable iPXE for the Raspberry Pi 4
=================================

piPXE is a build of the [iPXE] network boot firmware for the [Raspberry Pi].

Quick start
-----------

1. Bring TFTP/PXE server up – set variables according to your network. You can use .env file for convenience.
```
git clone https://github.com/valtzu/pixpe
cd pixpe/example
INTERFACE=eth0 SUBNET=192.168.1.0 NETMASK=255.255.255.0 docker-compose up
```
2. Power on your Raspberry Pi 4 with Ethernet cable attached to the same network as your $INTERFACE above
3. Wait a couple of minutes, it should load images directly from the [images.maas.io] (~500MB or so)
4. You can now SSH to the machine (get the IP from dnsmasq output for example), username `unsafe`, password `unsafe` 


Build from source
-----------
```
git clone https://github.com/valtzu/pixpe
cd pixpe
docker-compose up 
```

HTTP boot
-----------------------------------------

### Boot sequence
1. EEPROM loads `http://your-server/net_install/boot.img` and verifies it against `http://your-server/net_install/boot.sig`
2. `start4.elf` is launched (from `boot.img`)
3. UEFI (`RPI_EFI.fd`) is launched (from `boot.img`), defined in `config.txt`: `armstub=RPI_EFI.fd`
4. iPXE (embedded inside `RPI_EFI.fd` as EFI driver) is launched
5. iPXE looks up `autoexec.ipxe` from SD card or from TFTP server (which may be resolved using DHCP) 

Embedding iPXE script inside `boot.img` makes it possible to iPXE boot from internet, without SD card or TFTP server, eliminating step number 5 above.

### Implementation

1. Build `boot.img` with `docker-compose run --rm build make EMBED=/opt/build/autoexec.ipxe` (or wherever your ipxe script is)
2. Create 2048-bit RSA key pair in PEM format (Google is your friend)
3. Create `boot.sig` from `boot.img` with `rpi-eeprom-digest -i boot.img -o boot.sig -k your-private-key.pem`
4. Copy `boot.img` to your HTTP server (you may need to also sign it with `rpi-eeprom-digest`)
5. Flash EEPROM with your public key, `BOOT_ORDER`, `HTTP_HOST` etc. – but note that `HTTP_PATH` does not work and is always `net_install` (2022-04-02). See official [docs on HTTP boot](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#http-boot).

Licence
-------

Every component is under an open source licence.  See the individual
subproject licensing terms for more details:

* <https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom>
* <https://github.com/tianocore/edk2/blob/master/Readme.md>
* <https://ipxe.org/licensing>

[images.maas.io]: http://images.maas.io/ephemeral-v3/
[iPXE]: https://ipxe.org
[Raspberry Pi]: https://www.raspberrypi.org
[tftpboot.zip]: https://github.com/valtzu/pipxe/releases/latest/download/tftpboot.zip
[Etcher]: https://www.balena.io/etcher
[VC4 boot firmware]: https://github.com/raspberrypi/firmware/tree/master/boot
[TianoCore EDK2]: https://github.com/tianocore/edk2
