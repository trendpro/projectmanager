class ContactsSettingsController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id, :authorize 

  def save
    if params[:contacts_settings] && params[:contacts_settings].is_a?(Hash) then    
      settings = params[:contacts_settings]
      settings.map do |k, v|
        ContactsSetting[k, @project.id] = v
      end
    end
    redirect_to :controller => 'projects', :action => 'settings', :id => @project, :tab => params[:tab]
  end

end
