require File.expand_path('../../test_helper', __FILE__)  
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

class CommonViewsTest < ActionController::IntegrationTest
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
                             :deal_statuses,
                             :notes,
                             :roles,
                             :enabled_modules,
                             :tags,
                             :taggings,
                             :contacts_queries])   

  def setup
    RedmineContacts::TestCase.prepare

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_REFERER'] = '/'
  end  
  
  test "View user" do
    log_user("admin", "admin")
    get "/users/2"
    assert_response :success
  end  
  
  test "View contacts activity" do
    log_user("admin", "admin")    
    get "/projects/ecookbook/activity?show_contacts=1"
    assert_response :success
  end
  
  test "View contacts settings" do
    log_user("admin", "admin")    
    get "/settings/plugin/redmine_contacts"
    assert_response :success
  end 
  
  test "View contacts project settings" do
    log_user("admin", "admin")    
    get "/projects/ecookbook/settings/contacts"
    assert_response :success
  end

  test "View contact tag edit" do
    log_user("admin", "admin")    
    get "/contacts_tags/edit?id=1"
    assert_response :success
  end


  test "Global search with contacts" do
    log_user("admin", "admin")    
    get "/search?q=Domoway"
    assert_response :success
  end 

  test "View contacts project notes list" do
    log_user("admin", "admin")    
    get "/projects/ecookbook/contacts/notes"
    assert_response :success
  end 

  test "View contacts notes list" do
    log_user("admin", "admin")    
    get "contacts/notes"
    assert_response :success
  end 

  test "View issue contacts" do
    log_user("admin", "admin")    
    EnabledModule.create(:project_id => 1, :name => 'issue_tracking')
    issue = Issue.find(1)
    contact = Contact.find(1)
    issue.contacts << contact
    issue.save
    get "issues/1"
    assert_response :success
  end   

  test "View user with contact relation" do
    log_user("admin", "admin")    
    get "/users/2"
    assert_response :success
    # assert_tag :div,
    #   :content => /John Smith/,
    #   :attributes => { :class => 'contact card' }
  end 
  
end
