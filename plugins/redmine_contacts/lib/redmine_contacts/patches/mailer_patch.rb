module RedmineContacts
  module Patches    

    module MailerPatch
      module ClassMethods
      end

      module InstanceMethods
        def crm_note_add(note, parent) 
          redmine_headers 'Project' => note.source.project.identifier,
                          'X-Notable-Id' => note.source.id,
                          'X-Note-Id' => note.id
          @author = note.author
          message_id note
          recipients = (note.source.recipients + (parent ? parent.recipients : [])).uniq 
          cc = (parent ? (note.source.watcher_recipients + parent.watcher_recipients).uniq : note.source.watcher_recipients) - recipients
          @note = note
          @note_url = url_for(:controller => 'notes', :action => 'show', :id => note.id)
          mail :to => recipients,
               :cc => cc,
               :subject => "[#{note.source.project.name}] - #{parent.name + ' - ' if parent}#{l(:label_note_for)} #{note.source.name}"  

        end

        def crm_contact_add(contact) 
          redmine_headers 'Project' => contact.project.identifier,
                          'X-Contact-Id' => contact.id
          @author = contact.author
          message_id contact
          recipients = contact.recipients
          cc = contact.watcher_recipients - recipients
          @contact = contact
          @contact_url = url_for(:controller => 'contacts', :action => 'show', :id => contact.id)
          mail :to => recipients,
               :cc => cc,
               :subject => "[#{contact.project.name} - #{l(:label_contact)} ##{contact.id}] #{contact.name}"  

        end

        def crm_issue_connected(issue, contact)
          redmine_headers 'X-Project' => contact.project.identifier, 
                          'X-Issue-Id' => issue.id,
                          'X-Contact-Id' => contact.id
          message_id contact
          recipients contact.watcher_recipients 
          subject "[#{contact.projects.first.name}] - #{l(:label_issue_for)} #{contact.name}"  

          body :contact => contact,
               :issue => issue,
               :contact_url => url_for(:controller => contact.class.name.pluralize.downcase, :action => 'show', :project_id => contact.project, :id => contact.id),
               :issue_url => url_for(:controller => "issues", :action => "show", :id => issue)
          render_multipart('issue_connected', body)
        end

      end  
        
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do 
          unloadable   
          # TODO: Удалено из-за несовместимости, может быть косяк с шаблонами для майлера
          # self.instance_variable_get("@inheritable_attributes")[:view_paths] << RAILS_ROOT + "/vendor/plugins/redmine_contacts/app/views"
        end  
      end
      
    end

  end
end

unless Mailer.included_modules.include?(RedmineContacts::Patches::MailerPatch)
  Mailer.send(:include, RedmineContacts::Patches::MailerPatch)
end   

