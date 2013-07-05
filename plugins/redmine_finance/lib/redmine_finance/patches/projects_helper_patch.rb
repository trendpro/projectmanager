module RedmineFinance
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :project_settings_tabs, :finance          
        end
      end


      module InstanceMethods
        # include ContactsHelper

        def project_settings_tabs_with_finance
          tabs = project_settings_tabs_without_finance

          tabs.push({ :name => 'finance',
            :action => :edit_accounts,
            :partial => 'projects/finance_settings',
            :label => :label_finance_plural })
          tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}

        end
        
      end
      
    end
  end
end

unless ProjectsHelper.included_modules.include?(RedmineFinance::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, RedmineFinance::Patches::ProjectsHelperPatch)
end
