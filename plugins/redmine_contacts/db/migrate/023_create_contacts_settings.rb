class CreateContactsSettings < ActiveRecord::Migration
  def self.up
    create_table :contacts_settings do |t|
      t.column :name, :string
      t.column :value, :text
      t.column :project_id, :integer
      t.column :updated_on, :datetime
    end
    add_index :contacts_settings, :project_id
  end

  def self.down
    drop_table :contacts_settings
  end
end
