require File.dirname(__FILE__) + '/../../test_helper'  

class Redmine::ApiTest::NotesTest < ActionController::IntegrationTest
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

    ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/../../fixtures/', 
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
    Setting.rest_api_enabled = '1'
    RedmineContacts::TestCase.prepare
  end

  # context "POST /notes.xml" do
  #   should_allow_api_authentication(:post,
  #                                   '/notes.xml',
  #                                   {:note => {:project_id => 1, 
  #                                              :source_id => 1, 
  #                                              :source_type => 'Contact', 
  #                                              :content => 'API test'}},
  #                                   {:success_code => :created})
      
  #   should "create note with the attributes" do  
  #     assert_difference('Note.count') do
  #       post '/notes.xml', {:note => {:content => 'API test'},
  #                                     :project_id => 1, 
  #                                     :source_id => 1, 
  #                                     :source_type => 'Contact'}, credentials('admin')
  #     end

  #     note = Note.first(:order => 'id DESC')
  #     assert_equal 'API test', note.content
  
  #     assert_response :created
  #     assert_equal 'application/xml', @response.content_type
  #     assert_tag 'note', :child => {:tag => 'id', :content => note.id.to_s}
  #   end
  # end

  test "POST /notes.xml" do
    Redmine::ApiTest::Base.should_allow_api_authentication(:post,
                                    '/notes.xml',
                                    {:note => {:project_id => 1, 
                                               :source_id => 1, 
                                               :source_type => 'Contact', 
                                               :content => 'API test'}},
                                    {:success_code => :created})
  
      assert_difference('Note.count') do
        post '/notes.xml', {:note => {:content => 'API test'},
                                      :project_id => 1, 
                                      :source_id => 1, 
                                      :source_type => 'Contact'}, credentials('admin')
      end

      note = Note.first(:order => 'id DESC')
      assert_equal 'API test', note.content
  
      assert_response :created
      assert_equal 'application/xml', @response.content_type
      assert_tag 'note', :child => {:tag => 'id', :content => note.id.to_s}
  end


  test "PUT /notes/1.xml" do
      @parameters = {:note => {:content => 'API update'}}
    
      Redmine::ApiTest::Base.should_allow_api_authentication(:put,
                                    '/notes/1.xml',
                                    @parameters,
                                    {:success_code => :ok})
  
      assert_no_difference('Note.count') do
        put '/notes/1.xml', @parameters, credentials('admin')
        assert_response :success
      end
  
      note = Note.find(1)
      assert_equal "API update", note.content
    
  end
  

end
