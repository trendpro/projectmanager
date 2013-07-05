class Deal < ActiveRecord::Base  
  unloadable       
    
  belongs_to :project   
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id'    
  belongs_to :category, :class_name => 'DealCategory', :foreign_key => 'category_id'
  belongs_to :contact  
  belongs_to :status, :class_name => "DealStatus", :foreign_key => "status_id"  
  has_many :deals, :class_name => "deal", :foreign_key => "reference_id"
  has_many :notes, :as => :source, :class_name => 'DealNote', :dependent => :delete_all, :order => "created_on DESC"
  has_many :deal_processes, :dependent => :delete_all
  has_and_belongs_to_many :related_contacts, :class_name => 'Contact', :order => "#{Contact.table_name}.last_name, #{Contact.table_name}.first_name", :uniq => true

  def info  
   result = ""
  end

  private

  def helpers
    ActionController::Base.helpers
  end  
end
