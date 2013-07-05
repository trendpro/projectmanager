module RedmineContacts
  module Patches    

    module MyControllerPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          helper :deals, :contacts
          # TODO: Could be raseconditions
        end
      end
    end
    
  end
end

unless MyController.included_modules.include?(RedmineContacts::Patches::MyControllerPatch)
  MyController.send(:include, RedmineContacts::Patches::MyControllerPatch)
end
