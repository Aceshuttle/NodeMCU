wifi.setmode(wifi.STATIONAP)
station_cfg={}
station_cfg.ssid="IOT_B104"
station_cfg.pwd="iot_b104"
station_cfg.save=false
wifi.sta.config(station_cfg)
wifi.sta.connect()
tmr.alarm(1, 10000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
    tmr.stop(1)
    end
end)
pin = 2
tmr.alarm(2,5000,1,function()
status, temp, humi, temp_dec, humi_dec = dht.read(pin)
  if status == dht.OK then
     print("DHT Temperature:"..temp..";".."Humidity:"..humi)
     http.post('http://api.heclouds.com/devices/45673837/datapoints',
        'api-key: WEjHDNczdGOTZgzZKlwR=Im=rJo=\r\n',
        '{"datastreams":[{"id":"temperature","datapoints":[{"value":'..temp..'}]},{"id":"humidity","datapoints":[{"value":'..humi..'}]}]}',
        function(code, data)
        if (code < 0) then
        print("HTTP request failed")
        else
        print(code, data)
        end
        end)
  elseif status == dht.ERROR_CHECKSUM then
     print( "DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
     print( "DHT timed out." )
   end
end)


