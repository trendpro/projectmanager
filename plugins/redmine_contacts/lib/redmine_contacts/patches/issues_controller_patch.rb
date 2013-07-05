module RedmineContacts
  module Patches    

    module IssuesControllerPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          helper :contacts
        end
      end
    end
    
  end
end

unless IssuesController.included_modules.include?(RedmineContacts::Patches::IssuesControllerPatch)
  IssuesController.send(:include, RedmineContacts::Patches::IssuesControllerPatch)
end
