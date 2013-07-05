module RedmineFinance
  module Hooks
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        return content_tag(:style, "#admin-menu a.finance { background-image: url('/plugin_assets/redmine_finance/images/bank.png') }".html_safe, :type => 'text/css')
      end
    end
  end
end
