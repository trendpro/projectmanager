class OperationCategoriesController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_admin

  def new
    @category = OperationCategory.new
  end

  def create
    @category = OperationCategory.new(params[:category])
    if @category.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action =>"plugin", :id => "redmine_finance", :controller => "settings", :tab => 'operation_categories'
    else
      render :action => 'new'
    end
  end

  def edit
    @category = OperationCategory.find(params[:id])
  end

  def update
    @category = OperationCategory.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action =>"plugin", :id => "redmine_finance", :controller => "settings", :tab => 'operation_categories'
    else
      render :action => 'edit'
    end
  end

  def destroy
    OperationCategory.find(params[:id]).destroy
    redirect_to :action =>"plugin", :id => "redmine_finance", :controller => "settings", :tab => 'operation_categories'
  rescue
    flash[:error] = l(:error_unable_delete_category)
    redirect_to :action =>"plugin", :id => "redmine_finance", :controller => "settings", :tab => 'operation_categories'
  end   

end
