class ProjectsController < ApplicationController

  def index
      @project = Project.new
      @project_version = ProjectVersion.new
      @projects = Project.all

  end


  def new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project_version = ProjectVersion.new
    @project_version.project = @project
    @project_version.description = "initial commit"
    if @project.save
       @project_version.save
      redirect_to projects_path
    else
      render projects_path
    end
  end

  private

  def project_params
    params.require(:project).permit(:client, :description)
  end
end
