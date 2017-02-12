

local dht_pin = 1

local function readDHT()
    local status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
    if status == dht.OK then
        return temp, humi
--        print("DHT Temperature:"..temp..";".."Humidity:"..humi)
--    elseif status == dht.ERROR_CHECKSUM then
--        print( "DHT Checksum error." )
--    elseif status == dht.ERROR_TIMEOUT then
--        print( "DHT timed out." )
    else
        return -1000, -1000
    end
end

function periodic_measurement()
    if mykey == nil then
      print("No cred.")
      return
    end
    local time = rtctime.get()
    local temp, hum = readDHT()
    print("Meas: T=" .. temp .. ", RH=" .. hum)
    collectgarbage()
    local post = require("client_post")
    local json_t = post.create_json(temp, "C", time, lat, lon)
    post.post_json(server, url_t, json_t)
    json_t = nil
    tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()
        local json_h = post.create_json(hum, "%", time, lat, lon)
        post.post_json(server, url_h, json_h)
        json_h = nil
    end)
end

return { periodic = periodic_measurement }
