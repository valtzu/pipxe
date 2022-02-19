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
2. Power on your Raspberry Pi

Within a few seconds you should see iPXE appear and begin booting from
the network:

Build from source
-----------
```
git clone https://github.com/valtzu/pixpe
cd pixpe
docker-compose up 
```

Licence
-------

Every component is under an open source licence.  See the individual
subproject licensing terms for more details:

* <https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom>
* <https://github.com/tianocore/edk2/blob/master/Readme.md>
* <https://ipxe.org/licensing>

[iPXE]: https://ipxe.org
[Raspberry Pi]: https://www.raspberrypi.org
[pxe.zip]: https://github.com/valtzu/pipxe/releases/latest/download/pxe.zip
[Etcher]: https://www.balena.io/etcher
[VC4 boot firmware]: https://github.com/raspberrypi/firmware/tree/master/boot
[TianoCore EDK2]: https://github.com/tianocore/edk2
