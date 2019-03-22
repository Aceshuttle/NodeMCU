print('Setting up WIFI...')
wifi.setmode(wifi.STATIONAP)
station_cfg={}
station_cfg.ssid="PandoraBox"
station_cfg.pwd="1234567890"
station_cfg.save=false
wifi.sta.config(station_cfg)
wifi.sta.connect()
pin=4
gpio.mode(pin,gpio.OUTPUT)
tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print('Waiting for IP ...')
    else
        print('IP is ' .. wifi.sta.getip())
    tmr.stop(1)
    end
end)
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
  conn:on("receive", function(client, request)
    local buf = ""
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
    if (method == nil) then
      _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
    end
    local _GET = {}
    if (vars ~= nil) then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        _GET[k] = v
      end
    end
    buf = buf .. "<!DOCTYPE html><html><body><h1>Hello, this is NodeMCU.</h1><form src=\"/\">Turn PIN1 <select name=\"pin\" onchange=\"form.submit()\">"
    local _on, _off = "", ""
    if (_GET.pin == "ON") then
      _on = " selected=true"
      gpio.write(4, gpio.HIGH)
    elseif (_GET.pin == "OFF") then
      _off = " selected=\"true\""
      gpio.write(4, gpio.LOW)
    end
    buf = buf .. "<option" .. _on .. ">ON</option><option" .. _off .. ">OFF</option></select></form></body></html>"
    client:send(buf)
  end)
  conn:on("sent", function(c) c:close() end)
end)
