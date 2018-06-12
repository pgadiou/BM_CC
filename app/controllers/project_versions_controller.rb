class ProjectVersionsController < ApplicationController

  def new
  end

  def show
    @project_version = ProjectVersion.find(params[:id])
    @new_project_version = ProjectVersion.new
    @project = @project_version.project
    @accepted_companies = Company.where(project_version_id: @project_version.id, accepted: true)
    @unset_companies = Company.where(project_version_id: @project_version.id, unset: true)
  end

  def create
    @new_project_version = ProjectVersion.new(project_version_params)
    if @new_project_version.save
      redirect_to project_version_path(@new_project_version)
    else
      redirect_to root_path
    end
  end

  def mark_open_tab
    @project_version = ProjectVersion.find(params[:project_version_id])
    @project_version.update_attributes(open_tab: params[:open_tab])
    redirect_to @project_version
  end

  private

  def project_version_params
    params.require(:project_version).permit(:description, :project_id)
  end

end
