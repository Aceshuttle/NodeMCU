print('Setting up WIFI...')
wifi.setmode(wifi.STATIONAP)
station_cfg={}
station_cfg.ssid="IOT_B104"
station_cfg.pwd="iot_b104"
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
http.post('http://api.heclouds.com/devices/45673837/datapoints',
'api-key: WEjHDNczdGOTZgzZKlwR=Im=rJo=\r\n',
'{"datastreams":[{"id":"temp","datapoints":[{"value":"42}]}]}',
function(code, data)
if (code < 0) then
print("HTTP request failed")
else
print(code, data)
end
end)

