class AddTypeToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :type_id, :integer
    add_index :notes, :type_id
  end

  def self.down
    remove_column :notes, :type_id
  end
end
