
local dht_pin = 1

function readDHT()
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

