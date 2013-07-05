class OperationCategory < ActiveRecord::Base
  unloadable
  acts_as_list

  scope :named, lambda {|arg| where("LOWER(#{table_name}.name) = LOWER(?)", arg.to_s.strip)}

  validates_presence_of :name
  validates_uniqueness_of :name  
end
