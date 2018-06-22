class CompaniesController < ApplicationController

  def show
  end

  def import
    Company.import(params[:file], params[:project_version_id])
    redirect_to :back, notice: "Companies imported"
  end

  def update
    @company = Company.find(params[:id])
    @project_version = @company.project_version
    @company.update(selection_params)
    if @product.save
      respond_to do |format|
        format.html {redirect_to project_version_path(@project_version)}
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'project_versions/show'}
        format.js
    end
  end

  private

  def selection_params
    params.require(:company).permit(:unrelated_activity, :lack_information, :unrelated_function, :group)
  end


end
