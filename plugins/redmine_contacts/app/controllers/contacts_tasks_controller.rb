class ContactsTasksController < ApplicationController
  unloadable    
  
  before_filter :find_project_by_project_id, :except => [:close] 
  before_filter :find_issue, :except => [:new]
  before_filter :authorize_global, :only => [:close]
  before_filter :authorize, :only => [:add, :delete]
  before_filter :find_contact, :except => [:add, :close]    

  helper :contacts
  
  def new
    deny_access unless @contact.editable? || User.current.allowed_to?(:add_issues, @project)
    issue = Issue.new
    issue.project = @project
    issue.author = User.current
    issue.status = IssueStatus.default
    issue.start_date ||= Date.today
    issue.contacts << @contact
    issue.safe_attributes = params[:issue] if params[:issue]
    
    if issue.save
      flash[:notice] = l(:notice_successful_add)
      redirect_to :back
    else
      redirect_to :back 
    end           
  end   
  
  
  def add    
    @show_form = "true"    

    if params[:contact_id] && request.post? then    
      find_contact
      @contact.issues << @issue
      @contact.save
    end
    
    respond_to do |format|
      format.html { redirect_to :back }  
      format.js
    end
  end  

  def delete    
    @issue.contacts.delete(@contact)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end    
  end

  def close
    @issue.status = IssueStatus.find(:first, :conditions =>  { :is_closed => true })    
    @issue.save
    respond_to do |format|
      format.js   
      format.html {redirect_to :back }
    end
    
  end     
  
  private
  
  def find_contact 
    @contact = Contact.find(params[:contact_id]) 
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_issue 
    @issue = Issue.find(params[:issue_id]) 
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def assigned_to_users
    user_values = []  
    project = @project
    user_values << ["<< #{l(:label_all)} >>", ""]
    user_values << ["<< #{l(:label_me)} >>", User.current.id] if User.current.logged?
    if project
      user_values += project.users.sort.collect{|s| [s.name, s.id.to_s] }
    else
      project_ids = Project.all(:conditions => Project.visible_condition(User.current)).collect(&:id)
      if project_ids.any?
        # members of the user's projects
        user_values += User.active.find(:all, :conditions => ["#{User.table_name}.id IN (SELECT DISTINCT user_id FROM members WHERE project_id IN (?))", project_ids]).sort.collect{|s| [s.name, s.id.to_s] }
      end
    end    
  end
  
  
end
