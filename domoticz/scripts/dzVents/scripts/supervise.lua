return {
   active = true,
   on = { 
      devices = {
         '*'
      }
   },
   execute = function(domoticz, device)
   
    -- don't process
    local skip = function (T, S)
      -- domoticz.log('(scan) Type:'..T..' SubType:'..S)
      local pstatus = 0
      if (string.find(T, 'Temp')) then
        pstatus = 1
      end
      return pstatus
    end

    if (skip(device.deviceType, device.deviceSubType) == 1) then
      return  
    end
    
    localtime = '['..os.date('%d/%m/%y  %X')..'] '
    subject = device.name..' ['..device.id..'] '..device.state
    content = ''
    content = content .. '\\n ** date    = ' .. localtime
    content = content .. '\\n ** name    = ' .. device.name
    content = content .. '\\n ** id      = ' .. device.id
    content = content .. '\\n ** type    = ' .. device.deviceType
    content = content .. '\\n ** subtype = ' .. device.deviceSubType
    content = content .. '\\n ** state   = ' .. device.state

    sendMail = false
    
    if (string.find(device.deviceType, 'Lighting 2')) then
        content = content .. '\\n -- level : ' .. device.lastLevel .. ' > ' .. device.level
        sendMail = true
    elseif (device.deviceType == 'RFY') then
        sendMail = true
    elseif (device.deviceType == 'Lighting 1') then
        sendMail = true
    elseif (device.deviceType == 'Dimmer') then
        sendMail = true
    end
    
    if (sendMail) then
      domoticz.helpers.sendMail(domoticz, subject, content)
    end
      
   end
}
