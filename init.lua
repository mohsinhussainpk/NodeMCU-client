-- otherwise, start up
print('Running main.lc in 5 seconds')
-- dofile('main.lua')
tmr.alarm(0, 5000, tmr.ALARM_SINGLE, function() dofile("main.lc") end)

