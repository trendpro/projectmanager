require File.expand_path('../../test_helper', __FILE__)

class WikiControllerTest < ActionController::TestCase  
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
                             :roles,
                             :enabled_modules,
                             :tags,
                             :taggings,
                             :contacts_queries])   


  def setup
    EnabledModule.create(:project_id => 1, :name => 'wiki')
    @project = Project.find(1)
    @wiki = @project.wiki    
    @page_name = 'contact_macro_test'
    @page = @wiki.find_or_new_page(@page_name)
    @page.content = WikiContent.new
    @page.content.text = 'test'
    @page.save!    
  end
  
  def test_show_with_contact_macro
    @request.session[:user_id] = 1
    @page.content.text = "{{contact(1)}}"
    @page.content.save!
    get :show, :project_id => 1, :id => @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.wiki p', /Ivan Ivanov/    
  end

  def test_show_with_contact_avatar_macro
    @request.session[:user_id] = 1
    @page.content.text = "{{contact_avatar(1)}}"
    @page.content.save!
    get :show, :project_id => 1, :id => @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.wiki p img'
  end  

  def test_show_with_note_macro
    @request.session[:user_id] = 1
    @page.content.text = "{{contact_note(1)}}"
    @page.content.save!
    get :show, :project_id => 1, :id => @page_name
    assert_response :success
    assert_template 'show'
    assert_select 'div.wiki p', /Note 1 content with wiki syntax/    
  end

end
