wifi.setmode(wifi.STATIONAP)
station_cfg={}
station_cfg.ssid="IOT_B106"
station_cfg.pwd="iot_b106"
station_cfg.save=false
wifi.sta.config(station_cfg)
wifi.sta.connect()
tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
    tmr.stop(1)
    end
end)
temp = 55
hum = 58
tmr.alarm(2, 3000, 0, function()
str="{\r\n" 
        .."    \"datastreams\":[\r\n" 
        .."        {\r\n"  
        .."            \"id\":\"key\",\r\n" 
        .."            \"datapoints\":[\r\n"
        .."                {\r\n"  
        .."                    \"value\":\"123\"\r\n" 
        .."                }\r\n"  
        .."            ]\r\n"  
        .."        }\r\n"  
        .."    ]\r\n" 
        .."}"
print(str.." len: "..string.len(str))
sk=net.createConnection(net.TCP, 0)
sk:on("receive", function(sck, c) print(c) end ) 
sk:on("disconnection", function() print("tcp:disconnection") end )
sk:connect(80,"183.230.40.33")
sk:on("connection", function(sck,c)
print("tcp:connection")
sk:send(
"POST http://api.heclouds.com/devices/45672729/datapoints HTTP/1.1\r\n"
.."api-key: HXP9npYPeyRulZyOr4qU=PRqY4Q=\r\n"
.."Host: api.heclouds.com\r\n"
..str.."\r\n\r\n")
end)
end)
