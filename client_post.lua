
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

local function prepare_post (server, url, json_s)
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

local function parse_response(response)
     local x=response:find("\n")
     local code, text = string.match(response:sub(10,x-1), "(%d+) (%a+)")
     x=response:find("\r\n\r\n")
     local key=response:sub(x+4)
     return code, text, key
end

function post_json (server, url, json_s)
    if mykey == nil then
        print("No API key, will not send.")
        return
    end
    local sk = tls.createConnection(net.TCP, 1)
    sk:on("connection", function(conn)
        print("--connected")
        local post_s = prepare_post(server, url, json_s)
        print("--sending: " .. json_s)
        json_s = nil
        conn:send(post_s)
    end )
    sk:on("sent", function(conn, c)
        print("--sent")
    end)
    sk:on("receive", function(conn, c)
      local code, text, msg = parse_response(c)
      print("--received: " .. code .. ", " .. text .. ", message: " .. msg)
      conn:close()
    end)
    sk:on("disconnection", function(conn)  print("--disconnected") end )
    sk:connect(port,server)
end

return { create_json = create_json, post_json = post_json}
