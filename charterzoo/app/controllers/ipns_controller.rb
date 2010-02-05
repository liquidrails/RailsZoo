class IpnsController < ApplicationController
  protect_from_forgery :except => [:create]

  def notify
    @ipn = Ipn.find(:first, :conditions => "transaction_id = #{params[:txn_id]}")
    if nil == @ipn
       @ipn = Ipn.create!(:params => params, :status => params[:payment_status], :transaction_id => params[:txn_id], :email => params[:payer_email])
       logger.debug("something got created!")
       
    else
       logger.debug("something was already created! The id is #{@ipn.id}")
       @ipn.update_attributes(:params => params, :status => params[:payment_status], :email => params[:payer_email], :transaction_id => params[:txn_id] )
    end
      mark_as_purchased(@ipn)
      if nil == @ipn.email_sent_at && @ipn.status == "Completed"
        send_link_confirmation(@ipn)
      else
        render :nothing => true
      end   
  end


protected

  def mark_as_purchased(ipn)
    if ipn.status == "Completed"
       ipn.update_attributes(:purchased_at => Time.now)
       ipn.update_attributes(:code => genRandomKey())
       logger.debug("In mark_as_purchased!  :)") 
    end
  end

  def send_link_confirmation(ipn)
    email = CzMailer.create_linkconfirm(ipn)
    render(:text => "<pre>" + email.encoded + "</pre>")
  end

  def genRandomKey
    def String.random_alphanumeric(size=8)
    (1..size).collect { (i=Kernel.rand(62); i+=((i<10)?48:((i<36)?55:61))).chr}.join
    end
    return String.random_alphanumeric()
  end

end
