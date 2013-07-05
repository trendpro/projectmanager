require_dependency 'queries_helper'

module RedmineContacts
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :column_content, :contacts          
        end
      end


      module InstanceMethods
        # include ContactsHelper

        def column_content_with_contacts(column, issue)
          if column.name.eql? :contacts
      			column.value(issue).collect{ |contact| content_tag(
      				:span, 
      				link_to(avatar_to(contact, :size => "16"),
      						contact_path(contact), :id => "avatar") + ' ' + 
      						link_to_source(contact),
      				:class => "contact") }.join(', ')
          else
            column_content_without_contacts(column, issue)
          end
        end
      end
      
    end
  end
end

unless QueriesHelper.included_modules.include?(RedmineContacts::Patches::QueriesHelperPatch)
  QueriesHelper.send(:include, RedmineContacts::Patches::QueriesHelperPatch)
end
