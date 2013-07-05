module ActsAsTaggableOn::Taggable
  module Core    
    module InstanceMethods
      def tag_list_cache_on(context)
        variable_name = "@#{context.to_s.singularize}_list"
        if instance_variable_get(variable_name) 
          instance_variable_get(variable_name) 
        elsif self.class.respond_to?(:caching_tag_list_on?) && self.class.caching_tag_list_on?(context) && cached_tag_list_on(context)
          instance_variable_set(variable_name, ActsAsTaggableOn::TagList.from(cached_tag_list_on(context)))
        else
          instance_variable_set(variable_name, ActsAsTaggableOn::TagList.new(tags_on(context).map(&:name)))
        end 
      end
    end
  end
end
