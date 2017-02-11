-----------------------------------------------
--- Set Variables ---
-----------------------------------------------

--- IP CONFIG (Leave blank to use DHCP) ---
--ESP8266_IP=""
--ESP8266_NETMASK=""
--ESP8266_GATEWAY=""
-----------------------------------------------

--- Connect to the wifi network ---
print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_SSID, WIFI_PASSWORD)
wifi.sta.connect()
tmr.create():alarm(2000, tmr.ALARM_AUTO, function(cb_timer)
    if wifi.sta.getip() == nil then
        print("Waiting for IP address...")
    else
        cb_timer:unregister()
        print("WiFi connection established, IP address: " .. wifi.sta.getip())
        tmr.create():alarm(1, tmr.ALARM_SINGLE, function()
          do_clock_sync()
        end)
    end
end)
