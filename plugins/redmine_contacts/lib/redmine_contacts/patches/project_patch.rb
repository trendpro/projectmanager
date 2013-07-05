module RedmineContacts
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc: 
        base.class_eval do    
          unloadable # Send unloadable so it will not be unloaded in development
          has_and_belongs_to_many :contacts, :order => "#{Contact.table_name}.last_name, #{Contact.table_name}.first_name"  
          has_many :deals, :dependent => :delete_all 
          has_many :deal_categories, :dependent => :delete_all, :order => "#{DealCategory.table_name}.name"  
          has_and_belongs_to_many :deal_statuses, :uniq => true, :order => "#{DealStatus.table_name}.status_type, #{DealStatus.table_name}.position" 
        end  
      end  
    end
  end
end

unless Project.included_modules.include?(RedmineContacts::Patches::ProjectPatch)
  Project.send(:include, RedmineContacts::Patches::ProjectPatch)
end
