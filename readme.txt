#LESSONS
#1) host-python was removed leaving qt5webengine broken
#2) downloaded host-python without the patches and adjusted it
#3) qt5webengine seems to compile and use chromium
#4) changes in python27 flags prevented pyexpat to be built

manually added to nerves_defconfig (instead of: make menuconfig && make savedefconfig)

#required by dotnet
BR2_PACKAGE_ICU=y

#from https://github.com/nerves-web-kiosk/kiosk_system_rpi3/blob/main/nerves_defconfig
BR2_PACKAGE_DEJAVU=y
BR2_PACKAGE_QT5=y
BR2_PACKAGE_QT5BASE_SQLITE_SYSTEM=y
BR2_PACKAGE_QT5BASE_LINUXFB=y
BR2_PACKAGE_QT5BASE_DEFAULT_QPA="eglfs"
BR2_PACKAGE_QT5BASE_GIF=y
BR2_PACKAGE_QT5BASE_PNG=y
BR2_PACKAGE_QT5MULTIMEDIA=y
BR2_PACKAGE_QT5WEBENGINE=y
BR2_PACKAGE_SOCAT=y
BR2_PACKAGE_SUDO=y
BR2_PACKAGE_CA_CERTIFICATES=y
BR2_PACKAGE_LIBEVDEV=y
BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_EUDEV=y

mix compile
#fails an requests a extra packages
sudo apt install gcc-multilib
sudo apt install g++-multilib
#fails missing host-python-*


#tried this 
mix nerves.system.shell
make
exit

mix nerves.artifact
cp nerves_system_bbb_icu-portable-2.14.0-54BA3ED.tar.gz ~/.nerves/artifacts

#got host-python files from previous version where it was removed:
#https://github.com/buildroot/buildroot/commit/cb4ac01d5a282a1edd647b09576379094c5ed1d8
#https://github.com/buildroot/buildroot/tree/cb4ac01d5a282a1edd647b09576379094c5ed1d8/package/python

make[1]: *** No rule to make target 'host-python', needed by '/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/build/qt5webengine-5.15.2/.stamp_configured'.  Stop.
make: *** [Makefile:23: _all] Error 2

ImportError: No module named pyexpat
make host-python-dirclean
make host-python-rebuild

error: 'snd_seq_client_type_t' has not been declared
FAILED: obj/media/midi/midi/midi_manager_alsa.o
#https://sites.uclouvain.be/SystInfo/usr/include/sound/asequencer.h.html
make alsa-utils-dirclean
make alsa-utils-rebuild

make qt5webengine-dirclean
make qt5webengine-rebuild

/usr/bin/install: cannot stat '/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/host/arm-buildroot-linux-gnueabihf/sysroot/usr/bin/amidi': No such file or directory
make[1]: *** [package/pkg-generic.mk:383: /home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/build/alsa-utils-1.2.6/.stamp_target_installed] Error 1
make: *** [Makefile:23: _all] Error 2

FAILED: gen/services/metrics/public/cpp/ukm_builders.cc gen/services/metrics/public/cpp/ukm_builders.h gen/services/metrics/public/cpp/ukm_decode.cc gen/services/metrics/public/cpp/ukm_decode.h 
/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/host/bin/python2 ../../3rdparty/chromium/tools/metrics/ukm/gen_builders.py --input ../../3rdparty/chromium/tools/metrics/ukm/ukm.xml --output gen/services/metrics/public/cpp
Traceback (most recent call last):
  File "../../3rdparty/chromium/tools/metrics/ukm/gen_builders.py", line 58, in <module>
    sys.exit(main(sys.argv))
  File "../../3rdparty/chromium/tools/metrics/ukm/gen_builders.py", line 27, in main
    data = ReadFilteredData(args.input)
  File "../../3rdparty/chromium/tools/metrics/ukm/gen_builders.py", line 48, in ReadFilteredData
    data = ukm_model.UKM_XML_TYPE.Parse(ukm_file.read())
  File "/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/build/qt5webengine-5.15.2/src/3rdparty/chromium/tools/metrics/ukm/../common/models.py", line 367, in Parse
    tree = minidom.parseString(input_file)
  File "/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/host/lib/python2.7/xml/dom/minidom.py", line 1927, in parseString
    from xml.dom import expatbuilder
  File "/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/host/lib/python2.7/xml/dom/expatbuilder.py", line 32, in <module>
    from xml.parsers import expat
  File "/home/samuel/github/nerves_system_cpi/.nerves/artifacts/nerves_system_cpi-portable-1.19.0/host/lib/python2.7/xml/parsers/expat.py", line 4, in <module>
    from pyexpat import *
ImportError: No module named pyexpat
[42/17244] CXX obj/media/midi/midi/midi_manager_alsa.o
FAILED: obj/media/midi/midi/midi_manager_alsa.o 

use_glib=false enable_basic_printing=false enable_print_preview=false enable_pdf=false 
enable_plugins=false enable_spellcheck=true enable_webrtc=false 
audio_processing_in_audio_service_supported=false proprietary_codecs=false 
enable_extensions=false use_kerberos=false have_nodejs=true is_desktop_linux=false 
use_pulseaudio=false use_alsa=true

