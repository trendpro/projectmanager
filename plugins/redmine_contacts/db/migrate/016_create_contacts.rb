class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :middle_name
      t.string   :company
      t.text     :address
      t.string   :phone
      t.string   :email
      t.string   :website
      t.string   :skype_name
      t.date     :birthday
      t.string   :avatar
      t.text     :background
      t.string   :job_title
      t.boolean  :is_company,     :default => false
      t.integer  :author_id,      :default => 0,     :null => false
      t.integer  :assigned_to_id
      t.datetime :created_on
      t.datetime :updated_on
    end
    
    add_index :contacts, :author_id
    add_index :contacts, :is_company
    add_index :contacts, :company
    add_index :contacts, :first_name
    add_index :contacts, :assigned_to_id
    
  end

  def self.down
    drop_table :contacts
  end
end
