module RedmineFinance
  module Patches    
    
    module ContactPatch
      def self.included(base) # :nodoc: 
        base.class_eval do    
          has_many :operations, :dependent => :nullify
        end  
      end  

    end

  end
end

unless Contact.included_modules.include?(RedmineFinance::Patches::ContactPatch)
  Contact.send(:include, RedmineFinance::Patches::ContactPatch)
end
