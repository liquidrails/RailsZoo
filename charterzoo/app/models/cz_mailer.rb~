class CzMailer < ActionMailer::Base
  

  def linkconfirm(ipn)
    @subject = "Charterzoo Linkcode"
    @recipients = ipn.email
    @from  = "Charterzoo Webmaster"
    @sent_on = Time.now 
    @body["ipn"] = ipn   
    ipn.update_attributes(:email_sent_at => @sent_on)
  end

  def postconfirm(sent_at = Time.now)
    subject    'CzMailer#postconfirm'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
