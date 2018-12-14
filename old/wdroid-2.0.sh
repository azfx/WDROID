#!/bin/bash
##################################################################################
##### LICENSE ####################################################################
##################################################################################
####                                                                          ####
#### Copyright (C) 2018 wuseman <info@sendit.nu>                              ####
####                                                                          ####
#### This program is free software: you can redistribute it and/or modify     ####
#### it under the terms of the GNU General Public License as published by     ####
#### the Free Software Foundation, either version 3 of the License, or        ####
#### (at your option) any later version.                                      ####
####                                                                          ####
#### This program is distributed in the hope that it will be useful,          ####
#### but WITHOUT ANY WARRANTY; without even the implied warranty of           ####
#### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            ####
#### GNU General Public License at <http://www.gnu.org/licenses/> for         ####
#### more details.                                                            ####
####                                                                          ####
##################################################################################
##### GREETINGS ##################################################################
##################################################################################
####                                                                          ####
#### To all developers that contributes to all kind of open source projects   ####
#### Keep up the good work!                                                   #<3#
####                                                                          ####
#### https://sendit.nu & https://github.com/wuseman                           ####
####                                                                          ####
##################################################################################
#### DESCRIPTION #################################################################
##################################################################################
####                                                                          ####
#### wdroid is a console tool which is intended to facilitate                 ####
#### the work of adb and fastboot for android devices.                        ####
####                                                                          ####
#### Enjoy another awesome 'bash' script from wuseman. Questions? Conact me!  ####
####                                                                          ####
##################################################################################
#### USER SETTINGS ###############################################################
##################################################################################
ROOT="/var/git/wdroid/root-files-p8"                        ### Path To Files  ###
stock_recovery="$ROOT/w-stock-recovery.img"                 ### Stock Recovery ###
twrp_image="$ROOT/w-twrp-v2.0.img"                          ### TWRP IMAGE     ###
bootloader_key="<bootloader_key_here>"                      ### Bootloader key ###
magisk_zip="$ROOT/magiskmanager-v17.1.zip"                  ### Magisk ZIP     ###
magisk_apk="$ROOT/magiskmanager-v.6.0.1.apk"                ### Magisk Manager ###
device_pin="<pin_here>"                                     ### Device PIN     ###
sim_pin="<sim_pin>"                                         ### SimCard PIN    ###
##################################################################################
######## DONT TOUCH ANYTHING BELOW UNLESS YOU KNOW EXACTLY WHAT YOU ARE DOING ####
##################################################################################

if [[ $EUID -ne 0 ]]; then
    echo -e "\nYou must be Administrator to run this script\n" 2>&1
    exit 1

fi

banner() {
clear
cat << "EOF"
              _           _     _ 
             | |         (_)   | |
 __      ____| |_ __ ___  _  __| | Author: wuseman
 \ \ /\ / / _` | '__/ _ \| |/ _` | Version: 2.0
  \ V  V / (_| | | | (_) | | (_| | Contact: info@wuseman.com
   \_/\_/ \__,_|_|  \___/|_|\__,_|
==================================
EOF
}

# Short - Bootloader
bar() {
     echo "[+]==============================="
     echo -ne '[+][#                             ](1%)\r'; sleep 2    
     echo -ne '[+][#########                     ](27%)\r';sleep 2    
     echo -ne '[+][#############                 ](41%)\r';sleep 3    
     echo -ne '[+][###################           ](61%)\r';sleep 3    
     echo -ne '[+][######################        ](77%)\r';sleep 3    
     echo -ne '[+][########################      ](89%)\r';sleep 2     
     echo -ne '[+][##############################](100%)\r';echo -ne '\n'
     echo "[+]================================"

}

# Long Bar - Recovery
bar2() {
     echo "[+]=================================================="
     echo -ne '[+][#                                                ](1%)\r'; sleep 2    
     echo -ne '[+][#####                                            ](19%)\r';sleep 2    
     echo -ne '[+][########                                         ](27%)\r';sleep 2    
     echo -ne '[+][##########                                       ](39%)\r';sleep 2    
     echo -ne '[+][###############                                  ](41%)\r';sleep 2    
     echo -ne '[+][##################                               ](44%)\r';sleep 2    
     echo -ne '[+][#######################                          ](58%)\r';sleep 2    
     echo -ne '[+][#########################                        ](61%)\r';sleep 2    
     echo -ne '[+][###########################                      ](68%)\r';sleep 2    
     echo -ne '[+][#############################                    ](61%)\r';sleep 2    
     echo -ne '[+][###############################                  ](71%)\r';sleep 2    
     echo -ne '[+][#################################                ](74%)\r';sleep 2    
     echo -ne '[+][###################################              ](83%)\r';sleep 2    
     echo -ne '[+][#####################################            ](89%)\r';sleep 2     
     echo -ne '[+][############################################     ](98%)\r';sleep 2     
     echo -ne '[+][#################################################](100%)\r';echo -ne '\n'
     echo "[+]=================================================="

}

adb="$(which adb 2> /dev/null)"
distro="$(cat /etc/os-release | head -n 1 | cut -d'=' -f2)"

if [ -z "$adb" ]; then
 echo -e "\nThis tool require adb...\n"
  read -p "Want me to install adb for you? (yes/no) " adbinstall
fi

case $adbinstall in
     "yes")
        echo -e "\nPlease wait..\n"
      sleep 1
case $distro in
     "Gentoo")
        echo -e "It seems you running \e[1;32m$distro\e[0m wich is supported, installing adb....\n"
        emerge --ask android-tools ;;
     "Sabayon") 
        echo -e "It seems you running \e[1;32m$distro\e[0m wich is supported, installing adb....\n"
        emerge --ask android-tools ;;
     "Ubuntu") 
        echo -e "It seems you running \e[1;32m$distro\e[0m wich is supported, installing adb....\n"
        apt update -y; apt upgrade -y; apt-get install adb ;;
     "Debian") 
        echo -e "It seems you running \e[1;32m$distro\e[0m wich is supported, installing adb....\n"
        apt update -y; apt upgrade -y; apt-get install adb ;;
     "Raspbian") 
        echo -e "It seems you running \e[1;32m$distro\e[0m wich is supported, installing adb....\n"
        apt update -y; apt upgrade -y; apt-get install adb ;;
     "Mint") 
        echo -e "It seems you running \e[1;32m$distro\e[0m wich is supported, installing adb....\n"
        apt update -y; apt upgrade -y; apt-get install adb ;;
     "no") echo "Ok, go compile it yourself then mofo" ; exit ;;
esac
       echo -e "This tool is not supported for $distro, please go compile it from source instead...\n" 
esac

help() {
cat << "EOF"

wdroid - is a console tool which is intended to facilitate the work with adb and fastboot

 where:
      -4    Bruteforce Pinlock (4Pin)     
      -6    Bruteforce Pinlock (6Pin)     
      -c    Make a call
      -f    Flash Recovery With TWRP (Huawei Only)     
      -fs   Flash Device Back To Stockrom (Huawei Only)     
      -m    Flash Device With Magisk (Huawei Only)
      -h    Show this help     
      -r    Reboot device (bootloader|recovery|system)      
      -s    Check device status
      -rb   Relock Bootloader (Huawei Only)     
      -ub   Unlock Bootloader (Huawei Only)      
      -B    Print Battery Level
      -DS   Default Storage - (0=auto,1=device,2=sdcard) (Next Release)
      -I    Install Magisk Manager (Huawei Only)
      -FR   Factory Reset Your Device
      -S    Print Serial
      -T    Take a photo (--delay for take a photo after X seconds)
      -W    Print Stored SSID and PSK For Wi-fi  
      -UL   Unlock pinlock for device
      -US   Unlock pinlock for sim and device (after a reboot)

EOF
}

adb_reboot() {
case $2 in
          "bootloader") adb reboot bootloader;;
          "recovery") adb reboot recovery;;
          "system") adb reboot ;;
esac
}

# DISABLEDSINCE 7.1
#enable_usb_debugging() {
# settings list system
# adb shell settings put global development_settings_enabled 1 &> /dev/null
#echo "[+] Developer mode is now enable.."
#}

call() {
read -p "[+] Enter Nmumber: +46" number
read -p "[+] Do you want speaker on (y/n): " speaker
case $speaker in
           "y") adb shell am start -a android.intent.action.CALL -d tel:+46$number &> /dev/null; sleep 0.5; 
                adb shell service call audio 20 i32 1 # really?
                echo -e "[+] Dialing +46$number."
                read -p "[+] Press Any Key To End Call."
                adb shell input keyevent KEYCODE_ENDCALL
                echo -e "[+] Ended Call."; echo ""
                adb shell input keyevent 6
                exit 1 ;;
           "n") adb shell am start -a android.intent.action.CALL -d tel:+46$number &> /dev/null
                echo -e "[+] Dialing +46$number."
                read -p "[+] Press Any Key To End Call."
                adb shell input keyevent KEYCODE_ENDCALL
                echo -e "[+] Ended Call."; echo ""
                adb shell input keyevent 6; exit 1 ;;
esac
}


device_status() {
      if adb devices | sed 1d | grep device; then echo "[+] Device is connected: $(adb devices | awk '{print $1}' | sed 1d)"; else echo "[+] Device is not connected.."; fi | sed 1d; echo ""
}

relock_bootloader() {
     echo "[+] Relocking bootloader, press volume up followed by power on your phone..";bar; adb reboot; fastboot oem relock 5377505155372691;echo "[+] Done, phone will reboot and do a lowlevel format and then reboot to eRecovery.."
}

unlock_bootloader() {
     echo "[+] Rebooting device to bootloader";
     adb reboot bootloader;
     bar 
     fastboot oem unlock $bootloader_key &> /dev/null
     echo "[+] Press 'VOL UP' followed by 'POWER' on your device.."
     echo "[+] When you pressing YES your device will reboot into.."
     echo "[+] eRecovery, choose to download and reinstall, enjoy.."
}

flash_recovery() {
     echo "[+] Please wait.."
     echo "[+] Rebooting device into bootloader."; adb reboot bootloader; bar;echo "[+] Flashing recovery partition..";sleep 0.5;
     if fastboot flash recovery_ramdisk $twrp_image 2> /dev/null; then echo "[+] Successfully flashed recovery..";echo "[+] Rebooting device.."; fastboot reboot; else
     echo "[+] Failed to flash device, please do it manually. Aborted..";exit; fi
}

flash_magisk() {
     echo ""
     echo "[+] Please wait, rebooting device into recovery.."; adb reboot recovery;bar2;
     echo "[+] --> Device has now entered recovery mode (TWRP)";echo "[+] --> Now you need to press on 'Advanced' (DOWN LEFT)"
     echo "[+] --> And now you need to press 'ADB Sideload' (DOWN LEFT)"; echo "[+] --> Now just swipe to enable 'ADB Sideload'"
     echo "[+]====================================================="
     read -p "[+] Press enter when you see sideload is listening...";if adb sideload magiskmanager-v17.1.zip &> /dev/null; then
     echo "[+] Successfully flashed device with magisk..";echo "[+] Install magisk when device has booted up to system..";
     echo "[+] Enjoy your fully rooted Huawei device.."; echo "";else echo "[+] Something went wrong, please do it manally.."
     echo "[+] 'adb sideload $mzip";echo "[+] Aborted"; exit
     fi
}

wifi_ssidpsk() {
echo "Comming soon"
}

bruteforce4pin() {
screen="$(adb shell dumpsys nfc | grep 'mScreenState=')"
case $screen in
   "mScreenState=OFF") echo "Screen is already off! Great, moving on.." ;;
   "mScreenState=ON_UNLOCKED") echo "It seems screen is unlocked already, locking phone and turning screen off..."; adb shell input keyevent 26; echo -e "\nSuccessfully locked phone.." ;;
esac
   echo -e "\nTurning screen on.."
   adb shell input keyevent 26 && echo -e "\nSuccessfully started screen..\n" || echo "Failed to power on screen ; exit"
   echo -e "Bruteforce attack will now start, please do not touch phone..."
   adb shell input keyevent 82
   adb shell input swipe 407 1211 378 85
   for i in {0000..9999}; do
   echo -e "Trying pin :$i"
   for (( j=0; j<${#i}; j++ )); do
   adb shell input keyevent $((`echo ${i:$j:1}`+7))
   done
   adb shell input keyevent 66
   adb shell input swipe 407 1211 378 85
if ! (( `expr $i + 1` % 5 )); then
   adb shell input keyevent 66
   sleep 30
   adb shell input keyevent 82
   adb shell input swipe 407 1211 378 85
fi
   done
}

uninstall_bloatware() {
   echo "[+] Printing applications.."
   echo ""
   adb shell pm list packages | cut -d':' -f2
   echo ""
   read -p "[+] Enter Packages To Remove: " test
   echo "[+] Uninstalling $test -> $(adb shell pm uninstall --user 0 $test)"
}


unlock_pin() {
screen="$(adb shell dumpsys nfc | grep 'mScreenState=')"
case $screen in
      "mScreenState=ON_LOCKED") 
       echo "[+] Unlocking Device.."
       pincode="$pin_device"
       adb shell input keyevent 82
       adb shell input keyevent 82
       adb shell input text $pincode; sleep 0.4
       echo "[+] Unlocked Device.."; echo "" ;;
       "mScreenState=ON_UNLOCKED")
       echo "[+] Duh. device is already unlocked."; echo "" ;;
esac

}

unlock_sim() {
   echo "[+] Unlocking Sim"
   adb shell input keyevent 82
   adb shell input text $pin_sim; sleep 1.4
   echo "[+] Unlocked Sim"
   adb shell input keyevent 66; sleep 2.0
   echo "[+] Unlocking Device"
   adb shell input text $pin_device
   adb shell input keyevent 66
   echo "[+] Unlocked Device"
   echo ""
}

serial() {
echo "[+] Device SerialNo: $(adb shell getprop ro.serialno)";echo ""
}

battery() {
echo "[+] Battery Level: $(adb shell dumpsys power | grep mBatteryLevel= | cut -d'=' -f2)%";echo ""
}

android_version() {
echo "[+] Android Version: $(adb shell getprop ro.build.version.release)"; echo ""
}

wifi_psk() {
echo -e "============================================="
echo -e "Please wait, checking...                     "
echo -e "============================================="
adb shell 'su -c' cat /data/misc/wifi/WifiConfigStore.xml  | grep -i '"SSID">' -A3 | cut -d';' -f2 | cut -d'&' -f1  | grep -v '<' | sed 's/--//g'
echo -e "============================================="
}

take_photo() {
if [ "$1" = "--delay" ]; then
 echo -e "Launching camera.."
 adb shell "am start -a android.media.action.IMAGE_CAPTURE > /dev/null" && \
 sleep $2 && \
 adb shell "input keyevent 27"
 echo -e "Photo has been taken.."
 exit
else
screen="$(adb shell dumpsys nfc | grep 'mScreenState=')"
case $screen in
     "mScreenState=OFF") echo "Please wakeup your phone..'wdroid wakeup'" ;;
     "mScreenState=ON_UNLOCKED") adb shell input keyevent 4; adb shell input keyevent 3
                                 echo "Hold camera still...";sleep 0.3
                                 adb shell "am start -a android.media.action.IMAGE_CAPTURE &> /dev/null";sleep 0.2
                                 adb shell "input keyevent 27"; sleep 1; echo "Photo has been taken..";sleep 0.4; adb shell "input keyevent 66"; sleep 0.5
                                 pkill -9 Camera; adb shell input keyevent 6
esac
fi
}

install_magisk() {
if [ -a "$magisk_apk" ]; then
echo "[+] Installing magisk.."
if [ ! "$(adb install $magisk_apk)" ]; then 
echo "[+] Something went wrong. Aborted."; echo ""; else
echo "[+] Successfully installed magisk"
echo "[+] Your device is now fully unlocked.."; echo ""
fi
else
echo "[+] Cant find apk file."
echo ""
exit 0
fi
}


factory_reset() {
read -p "[+] Are you really SURE to factory reset your device (YES): " YESFFS
if [ $YESFFS = "YES" ]; then
adb shell  "su -c 'am broadcast -a android.intent.action.MASTER_CLEAR'" 
else
echo "[+] Aborted."
fi
}

flash_stockrom() {
echo "[+] Flashing Cache..............]"
echo "[+] ##                          ](03%)"
fastboot flash cache stockimages/stock-CACHE.img &> /dev/null
echo "[+] Flashing Kernel.............]"; sleep 1
echo "[+] ######                      ](19%)"
fastboot flash kernel stockimages/stock-KERNEL.img &> /dev/null
echo "[+] Flashing Ramdisk............]"; sleep 1
echo "[+] ###########                 ](39%)"
fastboot flash ramdisk stockimages/stock-RAMDISK.img &> /dev/null
echo "[+] Flashing Recovery Ramdisk...]"; sleep 1
echo "[+] ################            ](63%)"
fastboot flash recovery_ramdisk stockimages/stock-RECOVERY_RAMDISK.img &> /dev/null
echo "[+] Flashing System.............]"; sleep 1
echo "[+] ########################    ](93%)"
fastboot flash system stockimages/stock-SYSTEM.img &> /dev/null
echo "[+] Device has been restored....]"
echo "[+] ############################](100%)"
echo "[+] Rebooting device............]"
fastboot reboot
}

default_storage() {

echo "[+] Current Default Storage: $(adb shell pm get-install-location)"
#0=auto,1=device,2=sdcard
}
onoroff() {
isphoneconnected="$(adb devices | sed '1d' | sed '/^$/d')"
if [ ! $isphoneconnected 2> /dev/null ]; then
   banner
   echo ""
   echo " Your device is not connected properly.."
   echo ""
   exit
fi
}

if [ -z $1 ]; then
banner
echo ""
help
fi

case $1 in
          "-4")     banner;echo "";onoroff;bruteforce4pin ;;
          "-c")      banner;echo "";onoroff;call ;;
          "-f")     banner;echo "";onoroff;flash_recovery ;;
          "-fs")    banner;echo "";flash_stockrom ;;
          "-m")     banner;echo "";onoroff;flash_magisk ;;
          "-h")      banner;echo "";help;echo "";;
          "-r")      banner;echo "";onoroff;adb_reboot;;
          "-rb")     banner;echo "";onoroff; relock_bootloader ;;
          "-ub")     banner;echo "";onoroff; unlock_bootloader ;;
          "-s")     banner;echo "";device_status ;;
          "-B")      banner;echo "";onoroff;battery;;
          "-I")     banner;echo "";onoroff;install_magisk ;;
          "-FR")    banner;echo "";onoroff; factory_reset ;;
          "-W")      banner;echo "";onoroff;wifi_psk ;;
          "-S")      banner;echo "";onoroff;serial;;
          "-T")     banner;echo "";onoroff;take_photo;;
          "-UL")     banner;echo "";onoroff;unlock_pin;;
          "-US")     banner;echo "";onoroff;unlock_sim;;
          "*")        banned;echo "";onoroff;echo "Invalid Option" ;;


esac
