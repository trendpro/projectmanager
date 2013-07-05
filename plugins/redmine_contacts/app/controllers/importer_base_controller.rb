class ImporterBaseController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize  

  def new
    @importer = klass.new
    render 'importers/new'
  end

  def create
    @importer = klass.new(params[klass.to_s.underscore.to_sym])
    @importer.project = @project
    if @importer.file && @importer.save 
      redirect_to instance_index
    else
      render 'importers/new'
    end
  end
end
