
-- local config has priority over generic
if file.exists("config.lua.local")
  then dofile("config.lua.local")
  else dofile("config.lua")
end

dofile("sensors.lua")

dofile("client_post.lua")
dofile("client_credentials.lua")
dofile("ntp-clock.lua")

dofile("wifi_connect.lua")

function periodic_measurement()
    if mykey == nil then
      print("No credentials obtained yet.")
      return nil
    end
    local time = timestamp()
    local temp, hum = readDHT()
    print("Measurement done: T=" .. temp .. ", RH=" .. hum)
    local json_t = create_json(temp, "C", time, lat, lon)
    local json_h = create_json(hum, "%", time, lat, lon)
    local json_cred = create_json_cred()
    -- send with 10 seconds delay
    post_json_cred(server, url_cred, json_cred)
    tmr.create():alarm(15000, tmr.ALARM_SINGLE, function()
        post_json(server, url_t, json_t)
    end)
    tmr.create():alarm(30000, tmr.ALARM_SINGLE, function()
        post_json(server, url_h, json_h)
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
