#!/usr/bin/env bash
function makeScreenshot() {
  fullscreen="Make fullscreen screenshot"
  window="Make screenshot of a window"
  region="Make screenshot of a region"
  choice=$(echo -e "$fullscreen\n$window\n$region\n" | rofi -theme $HOME/.config/rofi/appLaunch.rasi -dmenu)
  case $choice in
    $fullscreen)
      scrot && notify-send "Scrot" "Screenshot was captured"
      ;; 
    $window)
      notify-send "Scrot" "You have a five seconds to focus an app"
      scrot -d 5 -u && notify-send "Scrot" "Screenshot was captured"
      ;;
    $region)
      scrot -s && notify-send "Scrot" "Screenshot was captured"
      ;;
  esac
}

function changeWiFiNetwork() {
  kitty sh -c "notify-send 'Wifi select' 'Wait a 5 second' && nmcli dev wifi"
  bssid=$(notify-send 'Change Wifi Network' 'Paste the name of Wifi Network in dmenu' && rofi -theme $HOME/.config/rofi/appLaunch.rasi -dmenu)
  password=$(notify-send 'Change Wifi Network' 'Paste the password, leave blank, if you do not have a password' && rofi -theme $HOME/.config/rofi/appLaunch.rasi -dmenu)
  if [[ -z $password ]]; then
    notify-send "Nmcli" "$(nmcli dev wifi connect $bssid)"
  else
    notify-send "Nmcli" "$(nmcli dev wifi connect $bssid password $password)"
  fi

}

function installPackages() {
  packages=$(notify-send "Pacman" "Write a packages through space" && rofi -theme $HOME/.config/rofi/appLaunch.rasi -dmenu)
  kitty sh -c "sudo pacman -Sy --noconfirm $packages && exit"
}
options=("Make a screenshot" "Change Wifi Network" "Change wallpaper" "Install packages")
amountOfOptions=4
accumulator=""

for i in "${options[@]}"; do
  accumulator="${accumulator}${i}"'\n'
done
choice=$(echo -e $accumulator | rofi -theme $HOME/.config/rofi/appLaunch.rasi -dmenu)
case $choice in
  ${options[0]})
    makeScreenshot
    ;;
  ${options[1]})
    changeWiFiNetwork
    ;;
  ${options[2]})
    killall xautolock
    bash $HOME/.config/i3/lockscreen
    ;;
  ${options[3]})
    installPackages
    ;;

  esac
