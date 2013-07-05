class ContactsProjectsController < ApplicationController
  unloadable
  
  before_filter :find_project_by_project_id, :authorize 
  before_filter :find_contact
  before_filter :check_count, :only => :delete

  helper :contacts
  
  def add
    @show_form = "true"          
    # find_contact
    if params[:new_project_id] then    
      project = Project.has_module(:contacts_module).find(params[:new_project_id])
      @contact.projects << project
      @contact.save if request.post?   
    end
    respond_to do |format|
      format.html { redirect_to :back }  
      format.js
    end
  rescue ::ActionController::RedirectBackError
    render :text => 'Project added.', :layout => true
  end

  def delete  
    @contact.projects.delete(Project.find(params[:disconnect_project_id])) if request.delete?
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {render :action => "add"}
    end    
  end
  
  private
  
  def check_count
    deny_access if @contact.projects.size <= 1 
  end
  
  def find_contact 
    @contact = Contact.find(params[:contact_id]) 
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
end
