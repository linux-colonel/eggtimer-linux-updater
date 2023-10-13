Eggtimer Firmware Update with Linux
===================================

This manual describes how to update the firmware on Eggtimer rocketry electronics using a Linux computer.

The steps were tested successfully on Debian 10 GNU/Linux, but should work with most distributions.

All instructions should be performed as a non-root user.  If root privileges are required, the command will be prefixed with `sudo`.

First, identify whether your device is ESP based or Atmel based (this is the CPU on the device) using the lists below.

ESP Based (WiFi) Devices
------------------------

* Eggtimer Proton
* Eggtimer Quantum
* Eggtimer Ion
* Eggtimer Quasar
* Eggtimer Wifi Switch
* Eggtimer Mini Switch

Atmel Based Devices
-------------------

* Eggtimer Classic
* Eggtimer TRS
* Eggfinder LCD Display
* Eggtimer Voice Module


Prerequisites
-------------

These steps only need to be done once on your Linux machine.

Install the following packages:

Note: `avrdude` is for Atmel based devices and `esptool` is for ESP based devices.

```
sudo apt -y install \
    avrdude \
    build-essential \
    git \
    screen

```

For ESP based devices, install esptool (it is NOT esptool.py that comes with the package manager or pip).

```
git clone https://github.com/igrr/esptool-ck
cd esptool-ck
make
mkdir -p ~/bin
cp esptool ~/bin

```

Add your user to the `dialout` group so it has permission to access the serial devices.


```
sudo usermod -a -G dialout $(id -un)
```

Important: Log out and log back in (or reboot) for this change to take effect.


Unpack the firmware
-------------------

Run these commands, substituting the text in `<brackets>`

```
git clone https://git.davidshewitt.com/linux-colonel/eggtimer-linux-updater.git
cd eggtimer-linux-updater
unzip ~/Downloads/<EggtimerFirmware>.zip
export PATH="~/bin:$PATH"
```

Determine the Serial Port
-------------------------

1. Plug in your USB to TTL cable to your device (Black -> GND, White -> TX, Green -> RX) and then your computer.
2. Determine the serial port.  It's most likely `/dev/ttyUSB0`.  Use `sudo dmesg` or `ls /dev/ttyUSB*` to help.
3. Run `screen /dev/ttyUSB0 9600` (Atmel), or `screen /dev/ttyUSB0 115200` (ESP) (point to device found in previous step) and turn on your device.  If you do not see text, reverse the white and green wires and try again.
4. Press **CTRL-A \ y** to close screen.  Power off your device.

Update the Firmware
-------------------

### Atmel Devices

1. Short the RESET pads / jumper.  Don't power on your device yet.
2. In your terminal, stage the update script (do not press ENTER yet), replacing the parameters in `<brackets>`: `./eggtimer-update-atmel.sh /dev/ttyUSB<0> <eggtimer-firmware>.hex`
3. Turn on your device, hit ENTER to run the command, and **immediately** remove the shorting jumper.
4. You should see a progress bar.  Allow the script to complete.  It will say *Update successful!* if it succeeds.  If not, repeat steps 1-3.

### ESP Devices

1. Short the PGM pads / jumper.  If the device is a Quasar, remove the jumper from the RUN pins and place it on the PGM pins.
2. In your terminal, stage the update script (do not press ENTER yet), replacing the parameters in `<brackets>`: `./eggtimer-update-esp.sh /dev/ttyUSB<0> <eggtimer-firmware>.bin`
3. Power on your device and press ENTER.
4. You should see text and a bunch of dots (.........) outputted.  Afterwards, the device will reboot and make its normal startup beeps.  It will say *Update successful!* if it succeeds.
