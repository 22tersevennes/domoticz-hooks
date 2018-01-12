return {

    active = function(domoticz) 
        -- domoticz.helpers.debug(domoticz, '(pilot-blind) BLIND_PILOT_ON_TEMP = '..domoticz.variables('BLIND_PILOT_ON_TEMP').value)
        if (domoticz.variables('BLIND_PILOT_ON_TEMP').value == 1) then
            return true
        end
            return false
        end
    ,
    on = { 
       devices = { 
            'Rez De Chaussée*'
        }
    },
    data = {
        previousTemp = { initial = -1000 },
        lastPos = { initial = '' }
    },
    execute = function(domoticz, device)

        -- device.dump()

        -- on the night : nothing to do 
        --if (not domoticz.time.isDayTime) then
        --    domoticz.helpers.debug(domoticz, '(pilot-blind) it is the night ')
        --    return
        --end

        min = 22.0
        max = 25.0
       
        currentTemp = device.temperature

        -- si la temperature > 25 et que ca n'a pas été bougé => MY
        -- si la temperature < 22 et que ca n'a pas été bougé => UP

        domoticz.helpers.debug(domoticz, '(pilot-blind) device : '..device.name..' ['..device.id..'] => '..currentTemp..' (previous='..domoticz.data.previousTemp..')')
        domoticz.data.previousTemp = device.temperature

    end
}