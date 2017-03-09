Terasys IoT Server
==============================
This readme document describes about the DHT11 sensor interfacing to NodeMCU (ESP8266) board and uploading the LUA firmware and client example to board, would send the temperature and humidity data to Terasys IoT server.


Hardware connection
-----------------------------
![Alt text](nodemcu10_layout.png?raw=true "NodeMCU board")


DHT11 Sensor interface to NodeMCU (ESP8266) board
------------------------------------------------------

![Alt text](DHT-connection.jpg?raw=true "DHT11 Sensor Interface")

YELLOW color wire -> SIGNAL or DATA pin
RED color wire -> VCC (3.3V)
BLACK color wire -> GND (Ground or reference)

Prerequisite Software
-------------------------
The following SWs to be installed on host PC (Linux or Windows or MAC)
- Required JAVA (SE version 7 and above) installed.
- Later version of python
- CH340/CH341 "USB to serial" drivers are needed for NodeMCU board.
https://github.com/nodemcu/nodemcu-devkit/tree/master/Drivers
In Windows, a succesful connect will create a new serial port, viewable in "Device manager" under "Ports (COM & LPT)"".

Downloading the LUA firmware into NodeMCU board
------------------------------------------------
- Download the LUA firmware (nodemcu-master-13-modules-2017-02-11-20-55-17-float.bin) from the following link. https://github.com/gabod2000/NodeMCU-client/tree/master/firmware/nodemcu-master-13-modules-2017-02-11-20-55-17-float.bin

- Download the following esptool which is used for flashing the LUA firmware into NodeMCU board.

	https://github.com/espressif/esptool
- Before uploading the firmware, erase the flash content of NodeMCU using the following command.

```sh
cd esptool-master
python esptool.py --port COM8 erase_flash
Ex:
E:\esptool-master> python esptool.py --port COM8 erase_flash
```

![Alt text](Flash2.png?raw=true "Erasing the NodeMCU")

- Program the downloaded LUA firmware into flash of NodeMCU using the following command.

```sh
cd esptool-master
python esptool.py --port COM8 write_flash 0x00000 nodemcu-master-13-modules-2017-02-11-20-55-17-float.bin
Ex:
E:\esptool-master> python esptool.py --port COM8 write_flash 0x00000 nodemcu-master-13-modules-2017-02-11-20-55-17-float.bin
```

![Alt text](Flash3.png?raw=true "Uploading LUA FW")

![Alt text](Flash4.png?raw=true "Uploading LUA FW")


- Wait for while till it format the SPI flash of NodeMCU and boot LUA code.

![Alt text](Flash5.png?raw=true "Uploading LUA FW")

![Alt text](Flash6.png?raw=true "Uploading LUA FW")


- Now NodeMCU is ready for uploading the Terasys LUA programs to communicate to IoT server.


Downloading the Terasys's LUA programs into NodeMCU board
----------------------------------------------------------
- Download the Terasys's LUA code (*.lua) from the following link.

https://github.com/gabod2000/NodeMCU-client/tree/master/src


- Modify the *config.lua* file for your WiFi router name and its password settings and also add your location details (GPS longitude and latitude)

- Using google maps, select your location, get the longitude & latitude values and use it in *config.lua* file.

```sh
Ex:
--- LOCATION ---
lat = 13.0377
lon = 80.2277

--- WIFI CONFIGURATION ---
WIFI_SSID = "mywifi_router"
WIFI_PASSWORD = "mywifi_password"
```

- Download the esplorer from the following link.

github.com/4refr0nt/ESPlorer

http://esp8266.ru/esplorer-latest/?f=ESPlorer.zip


- Run the ESPlorer.bat file.

- For start, one can use ESPlorer at https://esp8266.ru/esplorer/. Install, run, in the top of the right panel choose the appropriate COM port, speed 115200 and press open the port.

- By switching RTS icon ON and OFF, the device resets and restarts.

- The Lua prompt appears. Message about missing init.lua is normal.


![Alt text](Run1.png?raw=true "Uploading DHT11 LUA code")

![Alt text](ESPlorer (1).png?raw=true "Uploading DHT11 LUA code")


