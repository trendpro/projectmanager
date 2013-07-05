require File.expand_path('../../test_helper', __FILE__)      

class ContactsProjectsControllerTest < ActionController::TestCase  
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
    @controller = ContactsProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil    
  end
  
  test "should delete project" do
    @request.session[:user_id] = 1
    contact = Contact.find(1)
    assert_equal 2, contact.projects.size
    xhr :delete, :delete, :project_id => 1, :disconnect_project_id => 2, :contact_id => 1
    assert_response :success
    assert_include 'contact_projects', response.body
    
    contact.reload
    assert_equal [1], contact.project_ids
  end  
  
  test "should not delete last project" do
    @request.session[:user_id] = 1
    contact = Contact.find(1)
    assert RedmineContacts::TestCase.is_arrays_equal(contact.project_ids, [1, 2])
    # assert_equal '12', "#{contact.project_ids} || #{contact.projects.map(&:name).join(', ')} #{Project.find(1).contacts.map(&:name).join(', ')},  #{Project.find(2).name}"
    xhr :delete, :delete, :project_id => 1, :disconnect_project_id => 2, :contact_id => 1
    assert_response :success
    xhr :delete, :delete, :project_id => 1, :disconnect_project_id => 1, :contact_id => 1
    assert_response 403
    
    contact.reload
    assert_equal [1], contact.project_ids
  end

  test "should add project" do
    @request.session[:user_id] = 1

    xhr :post, :add, :project_id => "ecookbook", :new_project_id => 2, :contact_id => 2
    assert_response :success
    assert_include 'contact_projects', response.body
    contact = Contact.find(2)
    assert RedmineContacts::TestCase.is_arrays_equal(contact.project_ids, [1, 2])
  end  



  

end
