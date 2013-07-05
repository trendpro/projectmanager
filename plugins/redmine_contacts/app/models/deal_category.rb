class DealCategory < ActiveRecord::Base
  unloadable      
  belongs_to :project
  has_many :deals, :foreign_key => 'category_id', :dependent => :nullify
end
