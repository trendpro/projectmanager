require File.expand_path('../../test_helper', __FILE__)  

class ContactTest < ActiveSupport::TestCase
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


  # Replace this with your real tests.
  test "Should get first by email" do
    emails = ["marat@mail.ru", "domoway.mail.ru"]
    assert_equal 2, Contact.find_by_emails(emails).count
  end

  test "Should get first by second email" do
    emails = ["marat@mail.com"]
    assert_equal 1, Contact.find_by_emails(emails).count
  end

  def test_visible_public_contacts
    project = Project.find(1)
    contact = Contact.find(1)
    user = User.find(1) # John Smith

    contact.visibility = Contact::VISIBILITY_PUBLIC
    contact.save!

    assert contact.visible?(user)


  end

  def test_visible_scope_for_non_member_without_view_contacts_permissions
    # Non member user should not see issues without permission
    Role.non_member.remove_permission!(:view_contacts)
    user = User.find(9)
    assert user.projects.empty?
    contacts = Contact.visible(user).all
    assert contacts.empty?
    assert_visibility_match user, contacts
  end

  def test_visible_scope_for_member
    user = User.find(2)
    # User should see issues of projects for which he has view_issues permissions only
    role = Role.create!(:name => 'CRM', :permissions => [:view_contacts])
    Role.non_member.remove_permission!(:view_contacts)
    project = Project.find(2)
    Contact.delete_all
    Member.delete_all(:user_id => user)
    member = Member.create!(:principal => user, :project_id => project.id, :role_ids => [role.id])
    contact = Contact.create!(:project => project, :first_name => "UnitTest", :visibility => Contact::VISIBILITY_PUBLIC)

    contacts = Contact.visible(user).all

    assert contacts.any?
    assert_nil contacts.detect {|c| c.project.id != project.id }
    # assert_nil contacts.detect {|c| c.is_private?}
    assert_visibility_match user, contacts

    contact.visibility = Contact::VISIBILITY_PRIVATE
    contact.save!
    contacts = Contact.visible(user).all
    assert contacts.blank?, "Private contacts are visible"


    assert user.allowed_to?(:view_contacts, project)
    contact.visibility = Contact::VISIBILITY_PROJECT
    contact.save!
    contacts = Contact.visible(user).all
    assert contacts.any?, "Project contacts doesn't visible with permissions"

    role.remove_permission!(:view_contacts)
    user.reload
    contact.visibility = Contact::VISIBILITY_PROJECT
    contact.save!
    contacts = project.contacts.visible(user).all
    assert contacts.blank?, "Contacts visible for user without view_contacts permissions"    

    role.add_permission!(:view_private_contacts)
    user.reload
    contact.visibility = Contact::VISIBILITY_PRIVATE
    contact.save!
    contacts = Contact.visible(user).all
    assert contacts.any?, "Contacts note visible for user with view_private_contacts permissions"       
  end

  def test_visible
  end

  def assert_visibility_match(user, contacts)
    assert_equal contacts.collect(&:id).sort, Contact.all.select {|contact| contact.visible?(user)}.collect(&:id).sort
  end

end
