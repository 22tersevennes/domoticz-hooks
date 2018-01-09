return {
    active = true,
    on = { 
       devices = {
          'BlindPer*'
       }
    },
    execute = function(domoticz, device)

        duration = 13
        blindId = 39 -- Bureau

        state = device.state
        max = device.maxDimLevel
        prev = device.lastLevel
        current = device.level

        domoticz.log('(progressive) state='..state..' From:'..prev..' To:'..current)
        if (state == 'On' and prev ~= current) then
            step = duration * (current / 100)
            domoticz.log(' - je monte .')
            domoticz.log(' - j\'attends '..duration..' + 10% sec.')
            domoticz.log(' - je descends pendant '..step..' sec.')
            domoticz.log('(progressive) Run => '..step)
--            domoticz.devices(blindId).close()
--            domoticz.devices(blindId).open()
--            domoticz.devices(blindId).stop().after_sec(step)
        end
    end
}