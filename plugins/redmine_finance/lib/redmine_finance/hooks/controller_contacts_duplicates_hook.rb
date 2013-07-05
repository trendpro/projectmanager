module RedmineFinance
  module Hooks
    class ControllerContactsDuplicatesHook < Redmine::Hook::ViewListener
      def controller_contacts_duplicates_merge(context={})
        context[:duplicate].operations << context[:contact].operations
      end
    end
  end
end      
