require_dependency 'users_controller'  
require_dependency 'user' 

module RedmineContacts
  module Patches    
    module UsersControllerPatch
      
      def self.included(base) # :nodoc: 
        base.class_eval do
          helper :contacts
        end
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods  
        def new_from_contact
          contact = Contact.visible.find(params[:contact_id])
          @user = User.new(:language => Setting.default_language, :mail_notification => Setting.default_notification_option)
          @user.firstname = contact.first_name
          @user.lastname = contact.last_name
          @user.mail = contact.emails.first
          @auth_sources = AuthSource.find(:all)
          respond_to do |format|
            format.html { render :action => 'new' }
          end   
        end 

      end
    end
  end
end  

unless UsersController.included_modules.include?(RedmineContacts::Patches::UsersControllerPatch)
  UsersController.send(:include, RedmineContacts::Patches::UsersControllerPatch)
end
