#last release with kernel 4
#bcm2710-rpi-cm3 included
#OTP 23, Elixir 1.6
asdf local erlang 23.0.3 #match nerves version
asdf local elixir 1.13.4-otp-23
#https://github.com/nerves-project/nerves_system_rpi3/releases/tag/v1.12.2
Buildroot
2020.05.1
and OTP 23.0.3
Linux 4.19.118
{:nerves, "~> 1.5.4 or ~> 1.6.0", runtime: false},
{:nerves_system_br, "1.12.4", runtime: false},
{:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 1.3.0", runtime: false},
#https://github.com/nerves-project/nerves_system_rpi3/tree/a2a7e83ceeef3ffc44d06d51ff70072003778bef
#https://github.com/nerves-project/nerves_system_br/releases/tag/v1.12.4
#https://github.com/nerves-project/nerves_system_br/tree/567ead672954fe36bc4b8cbba02e64bfcb83ee8e
#https://github.com/nerves-project/nerves/releases/tag/v1.6.0 -> elixir-1.7-to-1.10 otp>=21
git checkout v1.12.2 
$(call github,raspberrypi,linux,raspberrypi-kernel_1.20200601-1)/linux-raspberrypi-kernel_1.20200601-1.tar.gz

rm -fr _build deps .nerves #critical if newer previous builds present in .nerves
mix deps.get
mix compile
#mix nerves.system.shell
mix nerves.artifact
#nerves_system_cpi-portable-1.12.2-0F5D88C.tar.gz
#nerves_system_cpi-portable-1.12.2-866187A.tar.gz
mv *.tar.gz ~/.nerves/artifacts/

mix nerves.new tryout
cd tryout 
#nerves -> comfile in config/target.exs
#set system path reference to ../
#downgrade to nerves 1.6.0
rm -fr _build deps .nerves mix.lock
mix archive.install hex nerves_bootstrap
MIX_TARGET=rpi3 mix deps.get
MIX_TARGET=rpi3 mix firmware
MIX_TARGET=rpi3 mix burn
MIX_TARGET=rpi3 mix firmware.gen.script

- boots ok: screen evidently smaller, dmesg and raspberries splash shown over iex
- mdns_lite not started shown once
- ssh 10.77.3.150 works (shows 22s uptime)
- reboot works on first boot
- neither comfile.local nor comfile-ee0c.local ping back
- MIX_TARGET=rpi3 mix upload 10.77.3.150 stalls
- MIX_TARGET=rpi3 ./upload.sh 10.77.3.150 stalls
- passing smsc95xx.macaddr=B8:27:EB:CF:EE:0C brings boot down to 7s!

- bumping nerves with override wont mount /root (/data)
- to merge config.txt keep kernel=zImage
- comfile cmdline.txt kernel panics bcm2835
- /data wont mount without CF config.txt
- :nerves_ssh wont start without rw /data
- eth0 slow detection
- delayed mounting of /root (just before eth0 detection)
- using rootfs_overlay/boot wont work
- putting config.txt in ../ wont mount /root (/data)
- config.txt must be replaced after image creation

Nerves.Runtime.reboot
Nerves.Runtime.halt
RingLogger.attach
RingLogger.tail

NEXT STEPS

- use elixir 1.7.3 or 1.8 required by nerves 1.6.3
- merge boot/*.txt official files
- solve mdns_lite startup
- enable fwup autodetection/umount
- add wx to erlang package
- merge with working comfile k4 image 4.19.97-v7+
- enable icu and test dotnet
- enable simple fb app tryout
- replicate by downgrading lastest nerves to kernel 4

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

iex(1)> cmd "cat /proc/version"
Linux version 4.19.118 (samuel@p3420) (gcc version 9.2.0 (crosstool-NG 1.24.0.71-4fa0ba1)) #2 SMP PREEMPT Fri Jun 24 00:24:49 CDT 2022
0

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

[   35.358263] EXT4-fs (mmcblk0p3): mounted filesystem with ordered data mode. Opts: (null)
[   36.261422] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
[   37.888751] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1


iex(1)> cmd "mount"
/dev/root on / type squashfs (ro,relatime)
devtmpfs on /dev type devtmpfs (rw,relatime,size=471528k,nr_inodes=117882,mode=755)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime,size=95228k)
tmpfs on /run type tmpfs (rw,nosuid,nodev,noexec,relatime,size=47616k,mode=755)
/dev/mmcblk0p1 on /boot type vfat (ro,nosuid,nodev,noexec,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,size=1024k,mode=755)
cpu on /sys/fs/cgroup/cpu type cgroup (rw,nosuid,nodev,noexec,relatime,cpu)
memory on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
/dev/mmcblk0p3 on /root type ext4 (rw,relatime)  ### THIS IS /data

iex(4)> Application.loaded_applications
[
  {:circular_buffer, 'General purpose circular buffer.\n', '0.4.1'},
  {:logger, 'logger', '1.13.4'},
  {:nerves_pack, 'Initialization setup for Nerves devices', '0.6.0'},
  {:uboot_env, 'Read and write to U-Boot environment blocks', '1.0.0'},
  {:ring_logger, 'A ring buffer backend for Elixir Logger with IO streaming',
   '0.8.5'},
  {:runtime_tools, 'RUNTIME_TOOLS', '1.15'},
  {:vintage_net_ethernet, 'Ethernet networking for VintageNet', '0.11.0'},
  {:kernel, 'ERTS  CXC 138 10', '7.0'},
  {:system_registry, 'Atomic nested term storage and dispatch registry\n',
   '0.8.2'},
  {:nerves_time, 'Keep time in sync on Nerves devices', '0.4.5'},
  {:compiler, 'ERTS  CXC 138 10', '7.6.2'},
  {:gen_state_machine, 'An Elixir wrapper for gen_statem.', '3.0.0'},
  {:beam_notify, 'Send a message to the BEAM from a shell script', '1.0.0'},
  {:property_table, 'In-memory key-value store with subscriptions', '0.2.0'},
  {:muontrap, 'Keep your ports contained', '1.0.0'},
  {:crypto, 'CRYPTO', '4.7'},
  {:vintage_net_direct, 'Direct Ethernet networking for VintageNet', '0.10.6'},
  {:ssh_subsystem_fwup,
   'Over-the-air updates to Nerves devices via an ssh subsystem', '0.6.1'},
  {:nerves_ssh, 'Manage a SSH daemon and subsystems on Nerves devices', '0.3.0'},
  {:one_dhcpd, 'One address DHCP server', '2.0.0'},
  {:vintage_net, 'Network configuration and management for Nerves', '0.12.1'},
  {:stdlib, 'ERTS  CXC 138 10', '3.13'},
  {:mdns_lite, 'A simple, no frills mDNS implementation in Elixir', '0.8.6'},
  {:toolshed, 'Use Toolshed for path completion and more helpers for IEx',
   '0.2.26'},
  {:iex, 'iex', '1.13.4'},
  {:tryout, 'tryout', '0.1.0'},
  {:nerves_motd, 'Message of the day for Nerves devices', '0.1.7'},
  {:ssh, 'SSH-2 for Erlang/OTP', '4.10'},
  {:public_key, 'Public key infrastructure', '1.8'},
  {:elixir, 'elixir', '1.13.4'},
  {:shoehorn, 'Get your boot on.', '0.8.0'},
  {:asn1, 'The Erlang ASN1 compiler version 5.0.13', '5.0.13'},
  {:nerves_runtime, 'Small, general runtime utilities for Nerves devices',
   '0.11.10'},
  {:vintage_net_wifi, 'WiFi networking for VintageNet', '0.11.0'}
]

06:02:14.327 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.335 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.344 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.352 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.361 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.366 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.372 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.377 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.385 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}                                                                      
        
06:02:14.390 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating           
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}                                
    :prim_socket.err/1                                                                                        
    :prim_socket.setopt/4                                                                                     
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2                    
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4                                              
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7                                                      
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3                                               
Last message: {:continue, :initialization}                                                                    
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}
        
06:02:14.394 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}
    :prim_socket.err/1
    :prim_socket.setopt/4
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:continue, :initialization}
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}
        
06:02:14.399 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}
    :prim_socket.err/1
    :prim_socket.setopt/4
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:continue, :initialization}
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}
        
06:02:14.406 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}
    :prim_socket.err/1
    :prim_socket.setopt/4
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:continue, :initialization}
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}
        
06:02:14.411 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}
    :prim_socket.err/1
    :prim_socket.setopt/4
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:continue, :initialization}
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}
        
06:02:14.416 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}
    :prim_socket.err/1
    :prim_socket.setopt/4
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:continue, :initialization}
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}
        
06:02:14.420 [error] GenServer {MdnsLite.ResponderRegistry, {"eth0", {10, 77, 3, 150}}} terminating
** (stop) {:invalid, {:not_supported, {:ip, :multicast_if, {10, 77, 3, 150}}}}
    :prim_socket.err/1
    :prim_socket.setopt/4
    (mdns_lite 0.8.6) lib/mdns_lite/responder.ex:127: MdnsLite.Responder.handle_continue/2
    (stdlib 3.13) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13) gen_server.erl:431: :gen_server.loop/7
    (stdlib 3.13) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: {:continue, :initialization}
State: %{cache: %MdnsLite.Cache{last_gc: -2147483648, records: []}, ifname: "eth0", ip: {10, 77, 3, 150}, select_handle: nil, skip_udp: nil, udp: nil}