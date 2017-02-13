

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
    local time = rtctime.get()
    local temp, hum = readDHT()
    print("Meas: T=" .. temp .. ", RH=" .. hum)
    collectgarbage()
    local post = require("client_post")
    local json_t = post.create_json(temp, "C", time, lat, lon)
    local json_h = post.create_json(hum, "%", time, lat, lon)
    local send_table = {{url_t, json_t},{url_h, json_h}}
    post.post_json(server, send_table)
end

return { periodic = periodic_measurement }
