require File.expand_path('../../test_helper', __FILE__)      

class ContactsTasksControllerTest < ActionController::TestCase  
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
                             :roles,
                             :enabled_modules,                             
                             :notes,
                             :tags,
                             :taggings,
                             :contacts_queries])              
  
  def setup
    RedmineContacts::TestCase.prepare

    @controller = ContactsTasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil    
    
    
  end
  

  test "should post new" do      
    @request.session[:user_id] = 1
    @request.env['HTTP_REFERER'] = '/contacts/1'
    post :new, :project_id => 1, :contact_id => 1, :task_subject => "test subject", :task_tracker => 1, :due_date => Date.to_s, :assigned_to => 1, :task_description => "Test task descripiton"    
    assert_response 302   
    # assert_not_nil Issue.find_by_subject("test subject")
  end

  test "should delete from issue" do      
    @request.session[:user_id] = 1
    issue = Issue.find(1)
    contact = Contact.find(1)
    issue.contacts << contact
    issue.save!
    assert issue.contact_ids.include?(1)
    xhr :delete, :delete, :project_id => 1, :contact_id => 1, :issue_id => 1
    assert_response 200   
    issue.reload
    assert !issue.contact_ids.include?(1)
  end
  
  test "should post close" do      
    @request.session[:user_id] = 1
    assert_not_nil Issue.find(1)
    xhr :post, :close, :issue_id => 1
    assert_response :success
  end
  

end
