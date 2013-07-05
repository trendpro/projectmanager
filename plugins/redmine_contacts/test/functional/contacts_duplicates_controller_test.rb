require File.expand_path('../../test_helper', __FILE__)      
# require 'contacts_duplicates_controller'

class ContactsDuplicatesControllerTest < ActionController::TestCase  
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries
 
    ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/../fixtures/', 
                            [:contacts,
                             :contacts_projects,
                             :contacts_issues,
                             :deals,
                             :notes,
                             :tags,
                             :taggings,
                             :contacts_queries])   
  
  def setup
    RedmineContacts::TestCase.prepare

    @controller = ContactsDuplicatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil  
  end
  
  test "should merge duplicates" do
    # log_user('admin', 'admin')   
    @request.session[:user_id] = 1
    Setting.default_language = 'en'
    
    get :merge, :project_id => 1, :contact_id => 1, :duplicate_id => 2
    assert_redirected_to :controller => "contacts", :action => 'show', :id => 2, :project_id => 'ecookbook'
    
    contact = Contact.find(2)
    assert_equal contact.emails, ["marat@mail.ru", "marat@mail.com", "ivan@mail.com"]
  end
  
end
