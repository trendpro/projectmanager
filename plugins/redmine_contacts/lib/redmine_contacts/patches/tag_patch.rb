module RedmineContacts
  module Patches    

    module TagPatch   
      module InstanceMethods    
        def color_name
          return "#" + "%06x" % self.color unless self.color.nil?
        end

        def color_name=(clr)
          self.color = clr.from(1).hex
        end

        def assign_color
          self.color = (rand * 0xffffff)  
        end
      end

      def self.included(base) # :nodoc: 
        base.send :include, InstanceMethods

        base.class_eval do    
          before_create :assign_color
        end  
      end  

    end 
  end
end    

unless ActsAsTaggableOn::Tag.included_modules.include?(RedmineContacts::Patches::TagPatch)
  ActsAsTaggableOn::Tag.send(:include, RedmineContacts::Patches::TagPatch)
end

