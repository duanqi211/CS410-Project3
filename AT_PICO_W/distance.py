import sys
shouldRun = str(input('Run? (y/n): ')).lower()
if shouldRun != 'y':
    sys.exit(1)
del sys

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
appAtSign = ''
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