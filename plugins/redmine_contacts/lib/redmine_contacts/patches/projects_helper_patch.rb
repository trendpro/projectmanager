require_dependency 'queries_helper'

module RedmineContacts
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :project_settings_tabs, :contacts          
        end
      end


      module InstanceMethods
        # include ContactsHelper

        def project_settings_tabs_with_contacts
          tabs = project_settings_tabs_without_contacts

          tabs.push({ :name => 'contacts',
            :action => :manage_contacts,
            :partial => 'projects/contacts_settings',
            :label => :label_contact_plural })
          tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}

        end
        
      end
      
    end
  end
end

unless ProjectsHelper.included_modules.include?(RedmineContacts::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, RedmineContacts::Patches::ProjectsHelperPatch)
end
