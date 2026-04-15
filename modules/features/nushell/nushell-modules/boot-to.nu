export def main [
  device: string@boot-devices # Identifier of device to boot to (e.g. 0003)
] {
  sudo efibootmgr --bootnext $device
  systemctl reboot
}

def boot-devices [] {
  efibootmgr | parse --regex 'Boot(?<value>\S+)\* (?<description>(?:\w+ )*\w+)'
}
