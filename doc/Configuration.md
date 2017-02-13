Configuration
=============

Before uploading the code to the unit, user should configure site-specific
data in two files: `config.lua` and `periodic_work.lua`.

`config.lua`
------------

1. server, port and API URLs,
 ```python
    server = "www.terasyshub.io"
    port = 443
    url_t = "/api/v1/data/temperature"
    url_h = "/api/v1/data/humidity"
    url_cred = "/api/v1/keys"
    ```
    The URLs should be adapted according to the endpoints of the
    quantities we are measuring.

2. time server
 ```python
    ntpserver = "pool.ntp.org"
    ```
  WARNING: `pool.ntp.org` is supposed resolve to a random timeserver in
  our vicinity.
  During testing it turned out that several of such servers are
  unreachable, therefore prolonging the boot time of the device for
  several minutes. It is advised, to find a local timeserver and
  define it in the line above instead of using pool.

3. location
 ```python
    lat = 0.00000
    lon = 0.00000
    ```
    East and north have positive, west and south have negative numbers.

4. wifi credentials, SSID and password.
 ```python
    WIFI_SSID = ""
    WIFI_PASSWORD = ""
    ```

`periodic_work.lua`
-------------------
Here, an exported function (`periodic()`) is defined, that performs all
the measuring and sending of the data. It is cron-called (from
`main.lua`) in regular intervals (e.g. 5 minutes). The function should
acquire data, prepare it for sending and send it to the server.
See the example code for DHT sensor.
