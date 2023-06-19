#!/bin/sh

# systemctl list-units --type target | grep graphical.target || exit 0

for i in /sys/bus/pci/devices/*/boot_vga; do
    if [ $(cat "$i") -eq 0 ]; then
        GPU="${i%/boot_vga}"
        AUDIO="$(echo "$GPU" | sed -e "s/0$/1/")"
        USB="$(echo "$GPU" | sed -e "s/0$/2/")"
        echo "vfio-pci $GPU/driver_override"
        echo "vfio-pci" > "$GPU/driver_override"
        if [ -d "$AUDIO" ]; then
            echo "vfio-pci $AUDIO/driver_override"
            echo "vfio-pci" > "$AUDIO/driver_override"
        fi
        if [ -d "$USB" ]; then
            echo "vfio-pci $USB/driver_override"
            echo "vfio-pci" > "$USB/driver_override"
        fi
    fi
done

modprobe -i vfio-pci
