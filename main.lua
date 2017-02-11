
dofile("config.lua")

dofile("sensors.lua")

dofile("client_post.lua")
dofile("ntp-clock.lua")

dofile("wifi_connect.lua")

function periodic_measurement()
    local time = timestamp()
    local temp, hum = readDHT()
    print("Measurement done: T=" .. temp .. ", RH=" .. hum)
    local json_t = create_json(temp, "C", time, lat, lon)
    local json_h = create_json(hum, "%", time, lat, lon)
    -- send with 10 seconds delay
    post_json(server, url_t, json_t)
    tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()
        post_json(server, url_h, json_h)
    end)
end

function periodic_measurement2()
    local time = timestamp()
    local temp, hum = readDHT()
    local json_t, json_h
    print("Measurement done: T=" .. temp .. ", RH=" .. hum)

    json_t = create_json(temp, "C", time, lat, lon)
    local url_t = "https://www.terasyshub.io/api/v1/data/temperature"
    http.post(url_t, "Content-Type: application/json\r\n", json_t, function(code, data)
        if (code < 0) then
          print("HTTPS temperature request failed")
        else
          print("temp", code, data)
        end
    end)

--    json_h = create_json(hum, "%", time, lat, lon)
--    local url_h = "https://www.terasyshub.io/api/v1/data/humidity"
--    http.post(url_h, "Content-Type: application/json\r\n", json_h, function(code, data)
--        if (code < 0) then
--          print("HTTPS humidity request failed")
--        else
--          print("hum", code, data)
--        end
--    end)

 end

-- every 5 minutes
cron.schedule("*/5 * * * *", function(e)
  print("Cron running measurement.")
  periodic_measurement()
end)

-- every day @ 2:22
cron.schedule("22 2 * * *", function(e)
  do_clock_sync()
end)
