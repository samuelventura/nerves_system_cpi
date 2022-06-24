#last release with kernel 4
#bcm2710-rpi-cm3 included
#OTP 23, Elixir 1.6
asdf local erlang 23.3.4.15
asdf local elixir 1.13.4-otp-23
#https://github.com/nerves-project/nerves_system_rpi3/releases/tag/v1.12.2
#https://github.com/nerves-project/nerves_system_rpi3/tree/a2a7e83ceeef3ffc44d06d51ff70072003778bef
#depends on 
#nerves_system_br 1.12.4
#nerves_toolchain_arm_unknown_linux_gnueabihf 1.3.0
#https://github.com/nerves-project/nerves_system_br/releases/tag/v1.12.4
#https://github.com/nerves-project/nerves_system_br/tree/567ead672954fe36bc4b8cbba02e64bfcb83ee8e
#https://github.com/nerves-project/nerves/releases/tag/v1.6.0 -> elixir-1.7-to-1.10 otp>=21
git checkout v1.12.2 

rm -fr _build deps .nerves #critical if newer previous builds present in .nerves
mix deps.get
mix archive.install hex nerves_bootstrap
mix compile
#mix nerves.system.shell
mix nerves.artifact
mv *.tar.gz ~/.nerves/artifacts/

mix nerves.new tryout
cd tryout 
#nerves -> comfile in config/target.exs
#set system path reference to ../
#downgrade to nerves 1.6.0
rm -fr _build deps .nerves
MIX_TARGET=rpi3 mix deps.get
MIX_TARGET=rpi3 mix firmware
MIX_TARGET=rpi3 mix burn
MIX_TARGET=rpi3 mix firmware.gen.script

- boots ok: screen evidently smaller, dmesg and raspberries splash shown over iex
- mdns_lite not started shown once
- ssh 10.77.3.150 works (shows 22s uptime)
- Nerves.Runtime.reboot works
- Nerves.Runtime.halt works
- reboot works on first boot
- neither comfile.local nor comfile-ee0c.local ping back
- MIX_TARGET=rpi3 mix upload 10.77.3.150 stalls
- MIX_TARGET=rpi3 ./upload.sh 10.77.3.150 stalls

NEXT STEPS

- confirm upload work consistently on bbb -> YES
- merge boot/*.txt official files -> Normal size screen
- backport fwup from bbb
- enable fwup autodetection/umount
- add wx to erlang package
- enable icu and test dotnet
- remove berries splash and dmesg log
- replicate by downgrading latest nerves to kernel 4

#https://github.com/erlang/otp/releases/tag/OTP-23.0.3
#https://github.com/erlang/otp/tree/44b6531bc575bac4eccab7eea2b27167f0d324aa
>>> erlang 23.0.3 Extracting
>>> erlang 23.0.3 Patching
>>> erlang 23.0.3 Updating config.sub and config.guess
>>> erlang 23.0.3 Patching libtool
>>> erlang 23.0.3 Configuring.
>>> erlang 23.0.3 Building....
>>> erlang 23.0.3 Installing to staging directory
>>> erlang 23.0.3 Fixing libtool files
>>> erlang 23.0.3 Installing to target
>>> rpi-firmware 1.20200601 Extracting
>>> rpi-firmware 1.20200601 Patching
>>> rpi-firmware 1.20200601 Configuring
>>> rpi-firmware 1.20200601 Building
>>> rpi-firmware 1.20200601 Installing to target
>>> rpi-firmware 1.20200601 Installing to images directory
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Extracting
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Patching
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Configuring
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Building.
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Installing to staging directory
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Fixing libtool files
>>> rpi-userland f97b1af1b3e653f9da2c1a3643479bfd469e3b74 Installing to target
>>> rpi-wifi-firmware d4f7087ecbc8eff9cb64a4650765697157821d64 Extracting
>>> rpi-wifi-firmware d4f7087ecbc8eff9cb64a4650765697157821d64 Patching
>>> rpi-wifi-firmware d4f7087ecbc8eff9cb64a4650765697157821d64 Configuring
>>> rpi-wifi-firmware d4f7087ecbc8eff9cb64a4650765697157821d64 Building
>>> rpi-wifi-firmware d4f7087ecbc8eff9cb64a4650765697157821d64 Installing to target

#will ignore this for now but keep an eye in case of miss configuration
Compiling 41 files (.ex)
warning: Mix.Config.persist/1 is deprecated. Use Application.put_all_env/2 instead
  lib/nerves/package.ex:171: Nerves.Package.load_nerves_config/1

Uploading to 10.77.3.150...
+ cat ./_build/rpi3_dev/nerves/images/tryout.fw
+ ssh -s 10.77.3.150 fwup
fwup: Upgrading partition B
  1% [                                    ] 65.54 KB in / 256.25 KB out  

#https://github.com/fwup-home/fwup
#https://github.com/nerves-project/nerves_system_rpi3/blob/main/fwup.conf
#https://github.com/fwup-home/fwup/issues/50 mentions SD size, block size, umount issues
#FWUP_MINIMAL removes autodetection
#HAS_UMOUNT required to support unmount
(cd ./_build/rpi3_dev/nerves/images/ && sftp 10.77.3.150)
put tryout.fw /tmp/
quit
ssh 10.77.3.150
cmd 'fwup /tmp/tryout.fw'
fwup: autodetection compiled out. specify a device (-d)
1

#manual device selection stalls as well
iex(6)> cmd 'fwup -a -i /tmp/tryout.fw -d /dev/mmcblk0 -t upgrade'            
fwup: umount /boot: not supported
fwup: umount /root: not supported
  5% [=                                   ] 737.28 KB in / 1.31 MB out    

iex(1)> cmd 'fwup -a -i /tmp/tryout.fw -d /dev/mmcblk0 -t upgrade'
fwup: umount /boot: not supported
fwup: umount /root: not supported
fwup: Upgrading partition B
 42% [===============                     ] 8.86 MB in / 10.57 MB out    

iex(1)> cmd 'fwup -a -U -i /tmp/tryout.fw -d /dev/mmcblk0 -t upgrade'
fwup: Upgrading partition B
 22% [=======                             ] 3.90 MB in / 5.55 MB out   

#after booting with config.merged.txt
fwup: Upgrading partition B
 92% [=================================   ] 21.12 MB in / 23.15 MB out   

athasha bbb mix upload works!
bbb depends on 
https://github.com/samuelventura/nerves_system_bbb_icu
nerves_system_br 1.19.0
nerves_toolchain_armv7_nerves_linux_gnueabihf 1.5.0
https://github.com/nerves-project/nerves_system_bbb/releases/tag/v2.14.0
https://github.com/nerves-project/nerves_system_bbb/tree/c2922e5dafcc62c204bf1dcb4cbeebeb1fb10c46
Buildroot 2022.02.1 and OTP 25.0 
http://buildroot.org/downloads/buildroot-2022.02.1.tar.gz
FWUP_VERSION = 1.9.0
dumps libsodium

#https://github.com/nerves-project/nerves_system_rpi3/releases/tag/v1.12.2
#https://github.com/nerves-project/nerves_system_rpi3/tree/a2a7e83ceeef3ffc44d06d51ff70072003778bef
#depends on 
#nerves_system_br 1.12.4
#nerves_toolchain_arm_unknown_linux_gnueabihf 1.3.0
Buildroot 2020.05.1 and OTP 23.0.3 
http://buildroot.org/downloads/buildroot-2020.05.1.tar.gz
FWUP_VERSION = 1.2.5
depends on libsodium

#second artifact build to force fwup19
#after setting up fwup19
mix nerves.system.shell
make fwup19
make
exit
mix nerves.artifact
#got same hash nerves_system_cpi-portable-1.12.2-E9CC34C.tar.gz
mv *.tar.gz ~/.nerves/artifacts/

cd tryout
MIX_TARGET=rpi3 mix firmware
MIX_TARGET=rpi3 mix burn
#from target iex (shows 1.8.0 before force fwup update!!!)
cmd "fwup --version"
1.9.0

#dmesg style errors: busy irq mmc0
#ssh connection refussed
#ip is configured but lots of error in RingLogger.tail

