require File.expand_path('../../test_helper', __FILE__)

class ContactsQueryTest < ActiveSupport::TestCase
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


  def test_project_filter_in_global_queries
    User.current = User.find_by_login('admin')
    query = ContactsQuery.new(:project => nil, :name => '_')
    tags_filter = query.available_filters["tags"]
    assert_not_nil tags_filter
    assert tags_filter[:values].flatten.include?("main")
  end

  def find_contacts_with_query(query)
    Contact.find :all,
      :include => [ :projects, :notes ],
      :conditions => query.statement
  end

  def assert_find_contacts_with_query_is_successful(query)
    assert_nothing_raised do
      find_contacts_with_query(query)
    end
  end

  def assert_query_statement_includes(query, condition)
    assert query.statement.include?(condition), "Query statement condition not found in: #{query.statement}"
  end
  
  def assert_query_result(expected, query)
    assert_nothing_raised do
      assert_equal expected.map(&:id).sort, query.issues.map(&:id).sort
      assert_equal expected.size, query.issue_count
    end
  end


end

