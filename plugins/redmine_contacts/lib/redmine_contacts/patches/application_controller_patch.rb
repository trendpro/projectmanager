module RedmineContacts
  module Patches
    module ApplicationControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :user_setup, :contacts
          helper :contacts, :deals, :notes
        end
      end

      module InstanceMethods
        def user_setup_with_contacts
          user_setup_without_contacts
          ContactsSetting.check_cache
        end

      end
    end
  end
end

unless ApplicationController.included_modules.include?(RedmineContacts::Patches::ApplicationControllerPatch)
  ApplicationController.send(:include, RedmineContacts::Patches::ApplicationControllerPatch)
end
