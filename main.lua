
-- local config has priority over generic
if file.exists("config.lua.local")
  then dofile("config.lua.local")
  else dofile("config.lua")
end

dofile("sensors.lc")
dofile("client_post.lc")
dofile("client_credentials.lc")
dofile("ntp-clock.lc")

dofile("wifi_connect.lc")


tmr.create():alarm(10000, tmr.ALARM_AUTO, function(cb_timer)
    if mykey == nil and wifi.sta.getip() ~= nil and timestamp() > 50000 then
          print("Acq creds.")
          acquire_credentials()
    elseif mykey ~= nil then
        cb_timer:unregister()
    end
end)


function periodic_measurement()
    if mykey == nil then
      print("No cred.")
      return
    end
    local time = timestamp()
    local temp, hum = readDHT()
    print("Meas: T=" .. temp .. ", RH=" .. hum)
    collectgarbage()
    local json_t = create_json(temp, "C", time, lat, lon)
    local json_h = create_json(hum, "%", time, lat, lon)
    post_json(server, url_t, json_t)
    json_t = nil
    tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()
        post_json(server, url_h, json_h)
        json_h = nil
    end)
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
