export def main [
  device: string@boot-devices # Identifier of device to boot to (e.g. 0003)
] {
  sudo efibootmgr --bootnext $device
  systemctl reboot
}

def boot-devices [] {
  let bootable_entries = efibootmgr | grep -E 'Boot\S+\*' | parse --regex '(?<identifier>\S+) (?<description>(?:\w+ )*\w+)'
  $bootable_entries | each {|it| {
    value: ($it.identifier | str replace -r 'Boot(.*)\*' '$1'),
    description: $it.description,
  } }
}
