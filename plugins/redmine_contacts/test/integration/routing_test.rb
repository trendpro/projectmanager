require File.expand_path('../../test_helper', __FILE__)  

class RoutingTest < ActionController::IntegrationTest

  test "contacts" do
    # REST actions
    assert_routing({ :path => "/contacts", :method => :get }, { :controller => "contacts", :action => "index" })
    assert_routing({ :path => "/contacts.xml", :method => :get }, { :controller => "contacts", :action => "index", :format => 'xml' })
    assert_routing({ :path => "/contacts.atom", :method => :get }, { :controller => "contacts", :action => "index", :format => 'atom' })
    assert_routing({ :path => "/contacts/notes", :method => :get }, { :controller => "contacts", :action => "contacts_notes" })
    assert_routing({ :path => "/contacts/1", :method => :get }, { :controller => "contacts", :action => "show", :id => '1'})
    assert_routing({ :path => "/contacts/1/edit", :method => :get }, { :controller => "contacts", :action => "edit", :id => '1'})
    assert_routing({ :path => "/contacts/context_menu", :method => :get }, { :controller => "contacts", :action => "context_menu" })
    assert_routing({ :path => "/projects/23/contacts", :method => :get }, { :controller => "contacts", :action => "index", :project_id => '23'})
    assert_routing({ :path => "/projects/23/contacts.xml", :method => :get }, { :controller => "contacts", :action => "index", :project_id => '23', :format => 'xml'})
    assert_routing({ :path => "/projects/23/contacts.atom", :method => :get }, { :controller => "contacts", :action => "index", :project_id => '23', :format => 'atom'})
    assert_routing({ :path => "/projects/23/contacts/notes", :method => :get }, { :controller => "contacts", :action => "contacts_notes", :project_id => '23'})

    assert_routing({ :path => "/contacts.xml", :method => :post }, { :controller => "contacts", :action => "create", :format => 'xml' })

    assert_routing({ :path => "/contacts/1.xml", :method => :put }, { :controller => "contacts", :action => "update", :format => 'xml', :id => "1" })

    assert_routing({ :path => "/contacts/bulk_edit", :method => :post }, { :controller => "contacts", :action => "bulk_edit" })
    assert_routing({ :path => "/contacts/bulk_edit", :method => :get }, { :controller => "contacts", :action => "bulk_edit" })
    assert_routing({ :path => "/contacts/context_menu", :method => :get }, { :controller => "contacts", :action => "context_menu" })
    assert_routing({ :path => "/contacts/send_mails", :method => :post }, { :controller => "contacts", :action => "send_mails" })
  end

   test "notes" do
    # REST actions
    assert_routing({ :path => "/notes/1", :method => :get }, { :controller => "notes", :action => "show", :id => '1'})
    assert_routing({ :path => "/notes/1/edit", :method => :get }, { :controller => "notes", :action => "edit", :id => '1'})
    assert_routing({ :path => "/notes/1", :method => :put }, { :controller => "notes", :action => "update", :id => '1'})
    assert_routing({ :path => "/notes", :method => :post }, { :controller => "notes", :action => "create"})
  end
end
