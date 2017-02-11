
function do_clock_sync ()
      sntp.sync("pool.ntp.org",
      function(sec, usec, server, info)
        print('Synced to epoch', sec, 'from server', server)
        local tm = rtctime.epoch2cal(rtctime.get())
        print(string.format("Now: %04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
      end,
      function()
        print('Clock sync failed, retrying!')
        tmr.create():alarm(1000, tmr.ALARM_SINGLE, function()
          do_clock_sync()
        end)
      end
    )
end

function timestamp ()
    local e = rtctime.get()
    return(e)
end

