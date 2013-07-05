class AddFieldsToDeals < ActiveRecord::Migration
  def self.up
    change_column :deals, :duration, :integer, :default => 1
    add_column :deals, :due_date, :timestamp
    add_column :deals, :probability, :integer
    
  end

  def self.down
    remove_column :deals, :due_date
    remove_column :deals, :probability
  end
end
