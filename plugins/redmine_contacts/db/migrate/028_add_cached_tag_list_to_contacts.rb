class AddCachedTagListToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :cached_tag_list, :string

  end

  def down
    remove_column :contacts, :cached_tag_list
  end
end
