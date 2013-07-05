class AccountsController < ApplicationController
  unloadable

  menu_item :operations

  before_filter :find_account, :only => [:show, :edit, :update, :destroy]
  before_filter :find_account_project, :only => [:new, :create]
  before_filter :find_optional_project, :only => :index
  before_filter :authorize, :except => :index

  helper :contacts
  helper :deals
  helper :watchers
  helper :custom_fields
  helper :timelog
  helper :attachments
  helper :issues
  include DealsHelper
  include AttachmentsHelper

  def index
    scope = Account.visible
    scope = scope.where(:project_id => @project) if @project
    @accounts = scope.order("#{Account.table_name}.name")
  end

  def show
    @operations = find_operations
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])  
    @account.project = @project
    if @account.save
      attachments = Attachment.attach_files(@account, (params[:attachments] || (params[:operation] && params[:operation][:uploads])))
      render_attachment_warning_if_needed(@account)      
      flash[:notice] = l(:notice_successful_create)
      
      respond_to do |format|
        format.html { redirect_to :action => "show", :id => @account }
        format.api  { render :action => 'show', :status => :created, :location => account_url(@account) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@account) }
      end
    end    
  end

  def update
    (render_403; return false) unless @account.editable_by?(User.current)
    if @account.update_attributes(params[:account]) 
      attachments = Attachment.attach_files(@account, (params[:attachments] || (params[:operation] && params[:operation][:uploads])))
      render_attachment_warning_if_needed(@account)
      flash[:notice] = l(:notice_successful_update)  
      respond_to do |format| 
        format.html { redirect_to :action => "show", :id => @account } 
        format.api  { head :ok }
      end  
    else           
      respond_to do |format|
        format.html { render :action => "edit"}
        format.api  { render_validation_errors(@account) }
      end
    end
  end

  def destroy
    (render_403; return false) unless @account.destroyable_by?(User.current)
    if @account.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    respond_to do |format|
      format.html { redirect_to :action => "index", :project_id => @account.project }
      format.api  { head :ok }   
    end 
  end

  private

  def find_account
    @account = Account.visible.find(params[:id], :include => :project)
    @project ||= @account.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_account_project
    project_id = params[:project_id] || (params[:account] && params[:account][:project_id])
    @project = Project.find(project_id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end 

  def find_operations(pages=true)  
    scope = @account.operations.scoped
    scope = scope.joins(:account => :project).where(:accounts => {:project_id => @project})
    scope = scope.includes(:contact, :category)

    scope = scope.where(:category_id => params[:category_id]) unless params[:category_id].blank?
    scope = scope.where(:contact_id => params[:contact_id]) unless params[:contact_id].blank?
    scope = scope.where(["#{Operation.table_name}.operation_date BETWEEN ? AND ?", @from, @to]) if @from && @to

    scope = scope.order("#{Operation.table_name}.operation_date DESC")
    scope = scope.visible
    
    @operations_count = scope.count

    if pages 
      @limit =  per_page_option 
      @operations_pages = Paginator.new(self, @operations_count, @limit, params[:page])     
      @offset = @operations_pages.current.offset  
       
      scope = scope.scoped :limit  => @limit, :offset => @offset
      @operations = scope
    end
    
    scope.all    
  end   

end
