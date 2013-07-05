module RedmineContacts
  module Patches    

    module SettingsControllerPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          helper :deals, :contacts
        end
      end
    end
    
  end
end

unless SettingsController.included_modules.include?(RedmineContacts::Patches::SettingsControllerPatch)
  SettingsController.send(:include, RedmineContacts::Patches::SettingsControllerPatch)
end
