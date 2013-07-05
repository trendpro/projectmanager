require File.expand_path('../../test_helper', __FILE__)

class ContactsSettingsControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :versions,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :time_entries

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
    @controller = ContactsSettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil    
  end
  
  test "should save setting" do
    @request.session[:user_id] = 1
    post :save, :project_id => 1, :contacts_settings => {:setting1 => 1, :setting2 => "Hello"}, :tab => 'contacts'
    assert_redirected_to :controller => 'projects', :action => 'settings', :tab => 'contacts', :id => "ecookbook"
    assert_equal "1", ContactsSetting[:setting1, 1]
    assert_equal "Hello", ContactsSetting[:setting2, 1]
  end  
 
end
