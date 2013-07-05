module RedmineContacts
  module Patches    

    module ProjectsControllerPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          helper :contacts
        end
      end
    end
    
  end
end

unless ProjectsController.included_modules.include?(RedmineContacts::Patches::ProjectsControllerPatch)
  ProjectsController.send(:include, RedmineContacts::Patches::ProjectsControllerPatch)
end
