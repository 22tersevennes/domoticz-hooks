return {
    helpers = {

        debug = function(domoticz, msg)

            if (domoticz.variables('MODE_DEBUG').value == 'YES') then
               domoticz.log('%DEBUG% '..msg, domoticz.LOG_FORCE)
            end
            
        end,

        -- send mail to address given by arg altMail or, if arg is not set, given by MAIL_TO domoticz variable
        sendMail = function(domoticz, subject, content, altMail)


            if (altMail ~= '' and altMail ~= nil) then
                mailTo = altMail
            else
                mailTo = (domoticz.variables('MAIL_TO').value or '')
                if (mailTo == '') then
                  domoticz.log('Set Domoticz variable MAIL_TO with an email MAIL_TO=email[ email]', domoticz.LOG_ERROR) 
                  return
                end
            end
        
            for k in string.gmatch(mailTo, '%S+') do
                domoticz.log(' -- mail address ['..k..'] ', domoticz.LOG_DEBUG)
                domoticz.email(subject, content, k) 
            end

        end

    }
}