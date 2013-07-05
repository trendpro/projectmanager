module RedmineContacts
  module Patches
    module NotifiablePatch
      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
            unloadable
            class << self
                alias_method_chain :all, :crm
            end
        end        
      end


      module ClassMethods
        # include ContactsHelper

        def all_with_crm
          notifications = all_without_crm
          notifications << Redmine::Notifiable.new('crm_contact_added')
          notifications << Redmine::Notifiable.new('crm_deal_added')
          notifications << Redmine::Notifiable.new('crm_deal_updated')
          notifications << Redmine::Notifiable.new('crm_note_added')
          notifications          
        end
        
      end
      
    end
  end
end

unless Redmine::Notifiable.included_modules.include?(RedmineContacts::Patches::NotifiablePatch)
  Redmine::Notifiable.send(:include, RedmineContacts::Patches::NotifiablePatch)
end
