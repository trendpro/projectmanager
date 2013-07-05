class CreateContactsRelations < ActiveRecord::Migration
  def self.up
    create_table :contacts_deals, :id => false do |t|
      t.integer :deal_id
      t.integer :contact_id
    end
    add_index :contacts_deals, [:deal_id, :contact_id]

    create_table :contacts_issues, :id => false do |t|
      t.integer :issue_id,   :default => 0, :null => false
      t.integer :contact_id, :default => 0, :null => false
    end
    add_index :contacts_issues, [:issue_id, :contact_id]

    create_table :contacts_projects, :id => false do |t|
      t.integer :project_id, :default => 0, :null => false
      t.integer :contact_id, :default => 0, :null => false
    end
    add_index :contacts_projects, [:project_id, :contact_id]
    
  end

  def self.down
    drop_table :contacts_deals
    drop_table :contacts_issues
    drop_table :contacts_projects
  end
end
