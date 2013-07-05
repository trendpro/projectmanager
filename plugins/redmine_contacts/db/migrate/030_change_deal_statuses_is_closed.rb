class ChangeDealStatusesIsClosed < ActiveRecord::Migration
  def up
    remove_column :deal_statuses, :is_closed
    add_column :deal_statuses, :status_type, :integer, :default => DealStatus::OPEN_STATUS, :null => false
  end

  def down
    remove_column :deal_statuses, :status_type
    add_column :deal_statuses, :is_closed, :boolean, :default => false, :null => false
  end
end
