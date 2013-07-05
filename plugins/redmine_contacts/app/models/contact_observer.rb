class ContactObserver < ActiveRecord::Observer
  def after_create(contact)
    Mailer.crm_contact_add(contact).deliver if Setting.notified_events.include?('crm_contact_added')
  end
end
