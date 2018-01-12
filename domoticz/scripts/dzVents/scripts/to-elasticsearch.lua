return {
    active = false -- true,
    on = { 
       devices = {
          '*'
       }
    },
    execute = function(domoticz, device)
    
        localtime = '['..os.date('%d/%m/%y  %X')..'] '
        -- domoticz.log('(to-elasticsearch:'..localtime..') name:'..device.name..' id:'..device.id..' type:'..device.deviceType..' stype:'..device.deviceSubType, domoticz.LOG_FORCE)
        -- device.dump();
        
        d = {}
        d.id = device.id
        d.did = device.deviceId
        d.name = device.name
        d.type = device.deviceType
        d.stype = device.deviceSubType
        d.lastUpdate = device.lastUpdate.raw
        d.battery = device.batteryLevel

        if (device.type == 'Temperature') then
            d.value = device._state
        end

    end
 }
 