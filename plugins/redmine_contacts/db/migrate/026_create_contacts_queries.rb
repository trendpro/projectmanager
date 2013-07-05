class CreateContactsQueries < ActiveRecord::Migration
  def self.up
    create_table :contacts_queries do |t|
      t.integer  :project_id
      t.string   :name,          :default => "",    :null => false
      t.text     :filters
      t.integer  :user_id,       :default => 0,     :null => false
      t.boolean  :is_public,     :default => false, :null => false
      t.text     :column_names
      t.text     :sort_criteria
      t.string   :group_by
      t.string   :type
    end
  end

  def self.down
    drop_table :contacts_queries
  end
end
