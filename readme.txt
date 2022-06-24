https://github.com/nerves-project/nerves_system_rpi3/releases/tag/v1.19.0
Buildroot 2022.02.1 and OTP 25.0

https://github.com/raspberrypi/linux/tree/fe2c7bf4cad4641dfb6f12712755515ab15815ca
fe2c7bf
on Apr 27, 2020
Git stats
Linux 4.19.118

git checkout v1.19.0
#FIX forgot to change project name and github organization
rm -fr _build deps .nerves
asdf local erlang 25.0.2
asdf local elixir 1.13.4-otp-25
mix deps.get
mix nerves.system.shell
make menuconfig
#select kernel fe2c7bf4cad4641dfb6f12712755515ab15815ca
make savedefconfig
make
exit
mix nerves.artifact #nerves_system_cpi-portable-1.19.0-226F218.tar.gz
mv *.tar.gz ~/.nerves/artifacts/

mix nerves.new tryout #no deps
cd tryout 

#nerves -> comfile in config/target.exs
#set system path reference to ../

rm -fr _build deps .nerves
mix archive.install hex nerves_bootstrap
MIX_TARGET=rpi3 mix deps.get
MIX_TARGET=rpi3 mix firmware
MIX_TARGET=rpi3 mix burn

#kernel panic not syncing attempted to kill init bcm2835

NEXT STEPS:

- confirm fwup works reliably
- get ramoops.dts from kernel4 branch (dit not remove panic)
- identify and apply patches for this kernel
- add initcall_blacklist=bcm2835_pm_driver_init (dit not remove panic)
