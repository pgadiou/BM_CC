class ProjectVersionsController < ApplicationController

  def new
  end

  def show
    @project_version = ProjectVersion.find(params[:id])
    @new_project_version = ProjectVersion.new
  end

  def create
    @new_project_version = ProjectVersion.new(project_version_params)
    if @new_project_version.save
      redirect_to project_version_path(@new_project_version)
    else
      cha
      redirect_to root_path
    end
  end

  private

  def project_version_params
    params.require(:project_version).permit(:description, :project_id)
  end

end
