class Task < ActiveRecord::Base              
  validates_presence_of :source_id, :issue_id, :source_type
  validates_uniqueness_of :source_id, :scope => [:issue_id, :source_type]                   
 
  after_save :send_mails
  
private

  def send_mails    
    Mailer.deliver_contacts_issue_connected(Contact.find(self.contact_id), Issue.find(self.issue_id)) 
    return true
  end
   
end
