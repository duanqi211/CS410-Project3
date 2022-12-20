# Robob Sensor

UMass 2022 IoT Projects.

# Table of Contents

- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Instructions](#instructions)
  * [1. Getting the right Micropython Firmware for your Pico W](#1-getting-the-right-micropython-firmware-for-your-pico-w)
  * [2. Getting Sarted - Blinking the LED](#2-getting-started---blinking-the-led)
  * [3. Git Cloning](#3-git-cloning)
  * [4. Connecting to WiFi](#4-connecting-to-wifi)
  * [5. Authenticating into your atSign's server](#5-authenticating-into-your-atsigns-server)
  * [6. Sending data](#6-sending-data)
  * [7. Receiving data](#7-receiving-data)
  * [8. Connect Raspberry Pi Pico with Distance Sensor](#8-connect-raspberry-pi-pico-with-distance-sensor)

# Prerequisites

- [VSCode](https://code.visualstudio.com/Download) with the [Pico-W-Go extension](https://marketplace.visualstudio.com/items?itemName=paulober.pico-w-go)
- [Git](https://git-scm.com/) and your own [GitHub](https://github.com) account
- A [Raspberry Pi Pico W](https://www.canakit.com/raspberry-pi-pico-w.html) and [a data micro-USB to USB-A cable](https://m.media-amazon.com/images/I/61kT7kpt2hL._AC_SY450_.jpg) (to connect your Pico to your Computer)
- [FileZilla](https://filezilla-project.org/) or any other FTP software.
- One [atSign](https://my.atsign.com/go) and its [.atKeys file](https://www.youtube.com/watch?v=2Uy-sLQdQcA&ab_channel=Atsign)

# Instructions

## 1. Getting the right Micropython Firmware for your Pico W

1. Go to [atsign-foundation/micropython/releases](https://github.com/atsign-foundation/micropython/releases) and download the `.uf2` file. This `.uf2` file is specially built firmware to allow a certain encryption that Atsign uses (AES-256 CTR mode) to work on the Pico W. Big shoutout to @realvarx for developing all the Atsign encryption for the Pico W. 

2. Unplug your Pico W from your computer. Hold down the BOOTSEL button on the Pico W and then plug back the Pico W into your computer (all while holding down the BOOTSEL button). Once the Pico W is plugged in, you can let go of the BOOTSEL button. Your Pico W should now be in bootloader mode. 

You should see the Pico on your computer as a USB drive.

3. Drag and drop the `firmware.uf2` file into the Pico W. This will flash the Pico W with the new firmware. Now the Pico W should automatically restart so no need to unplug/replug it.

## 2. Getting Started - Blinking the LED

1. Open VSCode and create and open an empty folder where your project will be.

2. Get the Pico-W-Go extension

3. Create a file named blink.py and write the following code:
```
import machine
import time

led = machine.Pin("LED", machine.Pin.OUT) # "LED" is the on board LED

# blink ten times
for i in range(10):
    print('Blinking... %s' %str(i+1))
    led.toggle()
    time.sleep(0.5)
 ```
4. Open the command pallette via Ctrl + Shift + P (or Cmd + Shift + P if you are on a Mac) and type Configure Project and press Enter. The extension should setup your current folder as a Pico W project by initializing a .vscode/ hidden folder and a .picowgo hidden file. Now, any Pico-W-Go commands should work. You can also access Pico-W-Go commands by clicking on "All Commands" at the bottom of VSCode.

VSCode bottom toolbar with Pico-W-Go commands:

![68747470733a2f2f692e6962622e636f2f67336a6d3533632f696d6167652e706e67](https://user-images.githubusercontent.com/91394288/208582425-fc238c1b-34a0-423b-8226-f973964cf5f5.png)

5. Now try connecting to your Pico W and see if it works. You can do this by clicking on the "Connect" button.

6. Make sure you have your blink.py python file open in the editor and Run the "Run current file" command. You should see the onboard LED blink 10 times.

## 3. Git Cloning

Now we know your Pico W is working swell, let's get into some atPlatform.

First, make sure you have [Git](https://git-scm.com/) installed.

1. Open VSCode and open an empty folder where you will be creating a new project.
2. Open the terminal (Ctrl + Shift + `)
3. Type `git clone https://github.com/atsign-foundation/at_pico_w.git .` to clone this repository into your current folder.
4. Go to the `umass2022` branch via `git checkout umass2022`

Now you should have all of the code in your folder. This is the fork you created on your GitHub account. Your folder should look something like this:

<img width=250px src="https://i.imgur.com/CC7bEFI.png">

5. Configure the project via Ctrl + Shift + P (or Cmd + Shift + P) and type `Configure Project` and press Enter just like before to setup the Pico project. Then run the `Upload Project` command.

## 4. Connecting to WiFi

1. Edit the `settings.json` by adding your WiFi and Password, leave the atSign blank for now.

settings.json

```json
{
	"ssid": "********",
	"password": "&&&&",
	"atSign": ""
}
```


2. You should see a file called `test_1_wifi.py` in your project (since you forked the repository). Open this file in VSCode and run the Pico-W-Go command "Run this current file".

3. The code is:
```py
def main():
    from lib.at_client import io_util
    from lib import wifi

    # Add your SSID an Password in `settings.json`
    ssid, password, atSign = io_util.read_settings()
    del atSign # atSign not needed in memory right now

    print('\nConnecting to %s (Ctrl+C to stop)...' % ssid)
    wlan = wifi.init_wlan(ssid, password)

    if not wlan == None:
        print('Connected to WiFi %s: %s' %(ssid, str(wlan.isconnected())))
    else:
        print('Failed to connect to \'%s\'... :(' %ssid)

if __name__ == '__main__':
    main()
```

4. Your output should be similar to:

```
Connecting to Soup (Ctrl+C to stop)...
Connected to WiFi Soup: True
```

## 5. Authenticating into your atSign's server

1. If you do not have all of the prerequisites, it is time to get them, especially: [FileZilla](https://filezilla-project.org/) or any other FTP software and one [atSign](https://my.atsign.com/go) and its [.atKeys file](https://www.youtube.com/watch?v=2Uy-sLQdQcA&ab_channel=Atsign). Continue reading to find out how to get your .atKeys files.

2. Add the atSign you wish your device's atSign to be in the `settings.json`. This is an atSign you own and got from [my.atsign.com/go](https://my.atsign.com/go).

settings.json

```
{
	"ssid": "******",
	"password": "***",
	"atSign": "@alice"
}

```

3. To get an .atKeys file belonging to an atSign, go to 0:54 of this [video](https://youtu.be/2Uy-sLQdQcA?t=54). The easiest way is to download [atmospherePro](https://atsign.com/apps/atmospherepro/) on your computer (via Microsoft Store on Windows or the Appstore if you're on Mac) and onboarding your atSign via the onboarding widget in the app. There are other ways to generate the encryption .atKeys file for an atSign (such as the [at_onboarding_cli on Dart](), [RegisterCLI on Java](), the [sshnp_register_tool in at_tools](), [OnboardingCLI in Java]()) but generating it through [atmospherePro](https://atsign.com/apps/atmospherepro/) is the easiest if you don't want to deal with any code. If you have an .atKeys file (like '@bob232.atKeys'), then move onto the next step. We are going to put our atKeys on the Pico W.

4. Run the "Start FTP server" command to start the FTP server on your Pico W Go. You should be given an address in the terminal (similar to the image below):

<img width=500px src="https://i.ibb.co/89mpzBh/image.png">

5. Open [FileZilla](https://filezilla-project.org/) and connect to this address. If it asks for a password, the password should be `pico`. If you've uploaded and files to the Pico before, you should see them once you've connected. Similar to below:

<image src="https://i.imgur.com/UaLQVdu.png" />

6. Create a `keys/` directory. This is where you will drag and drop the .atKeys file. Your `/keys/` directory should look like this:

<image src="https://i.imgur.com/wl2rIk8.png" />

7. Close the FTP server by pressing "Stop" on the bottom toolbar on VSCode.

Stop button:

<image src="https://i.imgur.com/RcxeSV5.png" />

Yay our FTP server is closed:

<image src="https://i.imgur.com/3FJg4Lc.png" />

7. Now let's initialize our keys in the Pico W by running `test_3_initializing_keys.py`. This decrypts the encryption keys and converts them to their n, e, p, d, q parameters which can be understood by the RSA library.

8. Re-open your FTP server, You should see a new folder in your `/keys/` directory on your Pico. This new folder should be named as your atSign (example `/keys/@alice/`). This is the decrypted keys in their n, e, p, d, q parameters. This is what the Pico W will use to authenticate into the atSign's server.

9. Close the FTP server.

10. Now we can test PKAM authenticating by running `test_4_pkam_authenticate.py`.  PKAM authenticating is essentially authenticating ourselves to the server so we can run commands like updating, deleting, and seeing values.

Output should be similar to:

<image src="https://i.imgur.com/01zt1BN.png">

If you don't see this, ensure your settings.json looks like this (with an atSign you own):

```json
{
	"ssid": "****",
	"password": "****",
	"atSign": "@fascinatingsnow"
}
```

and that you have the .atKeys file in the `/keys/` directory.

<image src="https://i.imgur.com/wl2rIk8.png" />

## 6. Sending data

1. Before moving on, make sure you've:

- Uploaded your .atKeys to the Pico W (via the FTP server)
- Have passed tests 1, 2, 3, and 4 (wifi, find secondary address, initializing keys, and pkam authenticating).

2. Copy the following code to 1. read the settings.json, 2. connect to the WiFi, and 3. authneticate into your atSign's server.

```py
# read settings.json
from lib.at_client.io_util import read_settings
ssid, password, atSign = read_settings()
del read_settings

# connect to wifi
print('Connecting to WiFi %s...' % ssid)
from lib.wifi import init_wlan
init_wlan(ssid, password)
del ssid, password, init_wlan

# authenticate into server
from lib.at_client.at_client import AtClient
atClient = AtClient(atSign, writeKeys=True)
del AtClient
atClient.pkam_authenticate(verbose=True)
```

3. Send data like so:

```py
# 'distance' is the key name
# `value` is the value you want to store into the server
# this will write the value into the device's atServer as a key like "public:led@bob" with value `value`.
data = atClient.put_public('distance', str(value)) # `data` is the response from the server. You will usually get a number (which is the commitId).
```

## 7. Receiving data

1. Just like in step 6, make sure you have done the following:

- Uploaded your .atKeys to the Pico W (via the FTP server)
- Have passed tests 1, 2, 3, and 4 (wifi, find secondary address, initializing keys, and pkam authenticating).
- Your other atSign has an existent public key on its atServer for it to be received by the Pico.

2. Copy the boiler plate code (same as Step 6)

```py
# read settings.json
from lib.at_client.io_util import read_settings
ssid, password, atSign = read_settings()
del read_settings

# connect to wifi
print('Connecting to WiFi %s...' % ssid)
from lib.wifi import init_wlan
init_wlan(ssid, password)
del ssid, password, init_wlan

# authenticate into server
from lib.at_client.at_client import AtClient
atClient = AtClient(atSign)
del AtClient
atClient.pkam_authenticate(verbose=True)
```

3. Receive data from another atSign's server like so:

```py
key = 'instructions' # the key that exists in the other atSign's server
appAtSign = '@smoothalligator' # the atSign you are receiving the data from
data = atClient.get_public(key, appAtSign)
```

## 8. Connect Raspberry Pi Pico with Distance Sensor

1. Connect your Raspberry Pi Pico to the HC-SR04 ultrasonic sensor.
![raspberry-pi-pico-ultrasonic-sensor-wiring](https://user-images.githubusercontent.com/91394288/208581510-cab343c6-0e33-4a5f-ac08-cdf3af3bb68e.png)
	
2. Create a file named blink.py and write the following code:
```
# read settings.json
import sys
shouldRun = str(input('Run? (y/n): ')).lower()
if shouldRun != 'y':
    sys.exit(1)
del sys

# connect to wifi
from lib.at_client.io_util import read_settings
ssid, password, atSign = read_settings()
del read_settings


print('Connecting to WiFi %s...' % ssid)
from lib.wifi import init_wlan
init_wlan(ssid, password)
del ssid, password, init_wlan

from lib.at_client.at_client import AtClient
atClient = AtClient(atSign)
del AtClient
atClient.pkam_authenticate(verbose=True)
	
import machine
from machine import Pin
import time
key = 'distance'
appAtSign = '' # add the atSign you are receiving the data from
trigger_pin=4
echo_pin=5
trigger=Pin(trigger_pin, Pin.OUT)
echo=Pin(echo_pin, Pin.IN)
led = machine.Pin("LED", machine.Pin.OUT)
while True:
    trigger.high()
    time.sleep_us(11)
    trigger.low()
    while (echo.value()==0):
        pass #wait for echo
    lastreadtime=time.ticks_us() # record the time when signal went HIGH
    while (echo.value()==1):
        pass #wait for echo to finish
    echotime=time.ticks_us()-lastreadtime
    if echotime>37000:
        print("No obstacle detected")
    if echotime <588:
        print("Careful!! Obstacle is close!")
        led.toggle()
        time.sleep(0.5)
        led.toggle()
    else:
        distance = (echotime * 0.034) / 2
        distance = atClient.get_public(key, appAtSign)
        print("Obstace distance= {}cm".format(distance))
    time.sleep(1)
```
3. Now try connecting to your Pico W and see if it works. You can do this by clicking on the "Connect" button.
		      
4. Run the "Run current file" command.
		      
5. As you put an object infront of the ultrasonic sensor it should display the distance between the sensor and the object, you should see the value changes as you moving the object closer or farer from the sensor.
