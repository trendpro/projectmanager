module RedmineFinance
  module Patches
    module NotifiablePatch
      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
            unloadable
            class << self
                alias_method_chain :all, :finance
            end
        end        
      end


      module ClassMethods
        # include ContactsHelper

        def all_with_finance
          notifications = all_without_finance
          notifications << Redmine::Notifiable.new('finance_account_updated')
          notifications          
        end
        
      end
      
    end
  end
end

unless Redmine::Notifiable.included_modules.include?(RedmineFinance::Patches::NotifiablePatch)
  Redmine::Notifiable.send(:include, RedmineFinance::Patches::NotifiablePatch)
end
