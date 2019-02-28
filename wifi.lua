gpio.mode(4, gpio.OUTPUT)
value = gpio.HIGH
wifi.setmode(wifi.STATIONAP)  
wifi.sta.config("IOT_B104","iot_b104") 
wifi.sta.connect() 
tmr.alarm(2,1000,1,function()
    if wifi.sta.getip() == nil then
        print("connecting...")
    else tmr.stop(2)
        print("connected,Ip is "..wifi.sta.getip()) 
    end
end)
srv=net.createServer(net.TCP,28800) 
srv:listen(8888,function(conn)  
    conn:on("receive",function(conn,payload)
    if (payload == "0") then
        tmr.stop(0)   
        gpio.write(4,gpio.LOW) 
    elseif (payload =="1") then
        tmr.stop(0)   
        gpio.write(4,gpio.HIGH) 
    elseif (payload =="2") then  
        value = gpio.HIGH
tmr.alarm(0, 300, 1, function ()
    gpio.write(4, value)
    if(value==gpio.HIGH)
    then
        value =gpio.LOW
    else
        value =gpio.HIGH
    end
end)
    end  
    print(payload) 
    end)
end)
