
#https://github.com/nerves-project/nerves_system_rpi3
#https://hexdocs.pm/nerves/customizing-systems.html

#https://github.com/buildroot/buildroot/blob/93f831bf5d90b689474671cc9bb790d2305fc07a/package/wpewebkit/wpewebkit.mk
#the workflow is to go to the package mk file to learn the flags
#that need to be added to nerves_defconfig instead of using make menuconfig
#after modifying nerves_defconfig exit and re-enter the nerves.system.shell

git clone git@github.com:nerves-project/nerves_system_rpi3.git nerves_system_cpi -b v1.19.0
cd nerves_system_cpi
mix deps.get
mix nerves.system.shell
make
exit
mix nerves.artifact
mv nerves_system_cpi-portable-1.19.0-3C66C49.tar.gz ~/.nerves/artifacts/

cd tryout/comfile
MIX_TARGET=rpi3 mix firmware
MIX_TARGET=rpi3 mix upload comfile.local

~/.ssh/config
Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
   LogLevel=ERROR

sudo badblocks -n -v /dev/sdd
