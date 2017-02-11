
function create_json_cred ()
    local data = {}
    data.mac = wifi.sta.getmac()
    return(cjson.encode(data))
end

function post_json_cred (server, url, json_s)
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
