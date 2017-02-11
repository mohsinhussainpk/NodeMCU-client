
function create_json (value, unit, time, lat, lon)
    local data = {}
    data.mac = wifi.sta.getmac()
    data.location = {lat=lat, lon=lon}
    data.timestamp = time
    data.value = value
    data.unit = unit
    data.key = mykey
    return(cjson.encode(data))
end

function prepare_post (server, url, json_s)
    local json_s_length = string.len(json_s)
    local post_s = "POST " .. url .. " HTTP/1.1\r\n"
            .. "Host: " .. server .. "\r\n"
            .. "Accept: */*\r\n"
            .. "User-Agent: Mozilla/4.0 (compatible; nodemcu esp8266 Lua;)\r\n"
            .. "Connection: close\r\n"
			.. "Content-Length: "..json_s_length.."\r\n"
            .. "Content-Type: application/json\r\n\r\n"
            .. json_s
    return(post_s)
end

function post_json (server, url, json_s)
    local sk = tls.createConnection(net.TCP, 1)
    sk:on("connection", function(conn)
        print("--connected")
        local post_s = prepare_post(server, url, json_s)
        print("Sending:")
        print(json_s)
        conn:send(post_s)
    end )
    sk:on("sent", function(conn, c)
        print("--sent")
    end)
    sk:on("receive", function(conn, c)
      print(c)
      conn:close()
    end)
    sk:on("disconnection", function(conn)  print("--disconnected") end )
    sk:connect(port,server)
end


