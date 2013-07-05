class DealStatus < ActiveRecord::Base
  unloadable
  
  OPEN_STATUS = 0
  WON_STATUS = 1
  LOST_STATUS = 2

  has_and_belongs_to_many :projects
  has_many :deals, :foreign_key => 'status_id', :dependent => :nullify
  has_many :deal_processes_from, :class_name => 'DealProcess',:foreign_key => 'old_value', :dependent => :delete_all
  has_many :deal_processes_to, :class_name => 'DealProcess', :foreign_key => 'value', :dependent => :delete_all
end
