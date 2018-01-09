return {
    helpers = {

        sendMail = function(domoticz, subject, content)

            mailTo = (domoticz.variables('MAIL_TO').value or '')
            if (mailTo == '') then
              domoticz.log('Set Domoticz variable MAIL_TO with an email MAIL_TO=email[ email]', domoticz.LOG_ERROR) 
              return
            end
        
            for k in string.gmatch(mailTo, '%S+') do
                domoticz.log(' -- mail address ['..k..'] ', domoticz.LOG_DEBUG)
                domoticz.email(subject, content, k) 
            end
        end
    }
}