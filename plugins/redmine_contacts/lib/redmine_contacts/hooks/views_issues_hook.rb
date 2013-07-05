module RedmineContacts
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener     
      # require_dependency "contacts_helper"

      render_on :view_issues_sidebar_planning_bottom, :partial => "issues/contacts", :locals => {:contact_issue => @issue}  

    end   
  end
end
