class CompaniesController < ApplicationController

  def show
  end

  def import
    Company.import(params[:file], params[:project_version_id])
    redirect_to :back, notice: "Companies imported"
  end

end
