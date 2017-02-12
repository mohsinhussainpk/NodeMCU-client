
function create_json_cred ()
    local data = {}
    data.mac = wifi.sta.getmac()
    return(cjson.encode(data))
end

function post_json_cred (server, url, json_s)
    local sk = tls.createConnection(net.TCP, 1)
    print(node.heap())
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
      local code, text, key = parse_response(c)
      print("Code: " .. code .. ", " .. text .. ", key: " .. key)
      mykey=key
      conn:close()
    end)
    sk:on("disconnection", function(conn)  print("--disconnected") end )
    sk:connect(port,server)
end

function parse_response(response)
     local x=response:find("\n")
     local code, text = string.match(response:sub(10,x-1), "(%d+) (%a+)")
     x=response:find("\r\n\r\n")
     local key=response:sub(x+4)
     return code, text, key
end

function acquire_credentials()
    local json_cred = create_json_cred()
    post_json_cred(server, url_cred, json_cred)
end
