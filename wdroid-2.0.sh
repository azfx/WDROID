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
# key=""                                      # Bootloader Key ###
# mzip="magiskmanager-v17.1.zip"                              # Magisk zip     ###
# mapk="magiskmanager-v.6.0.1.apk"                            # Magisk apk     ###
pincode="0000"
##################################################################################
######## DONT TOUCH ANYTHING BELOW UNLESS YOU KNOW EXACTLY WHAT YOU ARE DOING ####
##################################################################################

if [[ $EUID -ne 0 ]]; then
    echo -e "\nYou must be Administrator to run this script\n" 2>&1
    exit 1

fi

banner() {
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
  -f    Turn Flashlight ON or OFF
  -ds   Check device status
  -h    Show this help      
  -ul   Unlock pinlock for device
  -us   Unlock pinlock for sim and device (after a reboot)
  -s    Print Serial
  -b    Print Battery Level
  -w    Print Stored SSID and PSK For Wi-fi  
  -c    Make a call                 
  -b4   Bruteforce Pinlock (4Pin)     
  -r    Reboot device (bootloader|recovery|system)      
  -ru   Restart USB Mode
  -rw   Restart Wi-Fi Mode      
  -rb   Relock Bootloader (Huawei Only)     
  -ub   Unlock Bootloader (Huawei Only)      
  -fr   Flash Recovery With TWRP (Huawei Only)     
  -fm   Flash Device With Magisk (Huawei Only)
  -w    Print Stored SSID and PSK For Wi-Fi

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

flashlight() {
                adb shell 'su -c' echo 1 > /sys/class/leds/torch/brightness 
}

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
     fastboot oem unlock 5377505155372691 &> /dev/null
     echo "[+] Press 'VOL UP' followed by 'POWER' on your device.."
     echo "[+] When you pressing YES your device will reboot into.."
     echo "[+] eRecovery, choose to download and reinstall, enjoy.."
}

flash_recovery() {
     echo "[+] Please wait.."
     echo "[+] Rebooting device into bootloader."; adb reboot bootloader; bar;echo "[+] Flashing recovery partition..";sleep 0.5;
     if fastboot flash recovery_ramdisk w-twrp-v2.0.img 2> /dev/null; then echo "[+] Successfully flashed recovery..";echo "[+] Rebooting device.."; fastboot reboot; else
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

restart_usb() {
if adb usb; then echo echo "[+] Restarted usb mode.."; else echo "[+] Something went wrong, cant restart usb mode.. Aborted"; fi
}

restart_wifi() {
if adb wifi; then echo echo "[+] Restarted wifi mode.."; else echo "[+] Something went wrong, cant restart wifi mode.. Aborted"; fi
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
       pincode=$pin
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
   adb shell input text $pincode; sleep 1.4
   echo "[+] Unlocked Sim"
   adb shell input keyevent 66; sleep 2.0
   echo "[+] Unlocking Device"
   adb shell input text $pincode
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

takephoto() {
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



onoroff() {
isphoneconnected="$(adb devices | sed '1d' | sed '/^$/d')"
if [ ! $isphoneconnected 2> /dev/null ]; then
   banner
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
          "-f")      banner;echo "";onoroff;flashlight;;
          "-ul")     banner;echo "";onoroff;unlock_pin;;
          "-ub")     banner;echo "";onoroff;uninstall_bloatware;;
          "-us")     banner;echo "";onoroff;unlock_sim;;
          "-s")      banner;echo "";onoroff;serial;;
          "-b")      banner;echo "";onoroff;battery;;
          "-w")      banner;echo "";onoroff;wifi_psk ;;
          "-c")      banner;echo "";onoroff;call ;;
          "-ds")     banner;echo "";device_status ;;
          "-b4")     banner;echo "";onoroff;bruteforce4pin ;;
          "-h")      banner;echo "";help;echo "";;
          "-r")      banner;echo "";onoroff;adb_reboot;;
          "-ru")     banner;echo "";onoroff;restart_usb ;;
          "-rw")     banner;echo "";onoroff;restart_wifi ;;
          "-rb")     banner;echo "";onoroff; relock_bootloader ;;
          "-ub")     banner;echo "";onoroff; unlock_bootloader ;;
          "-fr")     banner;echo "";onoroff;flash_recovery ;;
          "-fm")     banner;echo "";onoroff;flash_magisk ;;
esac
