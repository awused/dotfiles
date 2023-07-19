#!/usr/bin/bash

# Goes in /usr/lib/dracut/modules.d/40vfio

check() {
  return 0
}
depends() {
  return 0
}
install() {
  declare moddir=${moddir}
  inst_hook pre-udev 00 "$moddir/vfio-pci-override.sh"
}
