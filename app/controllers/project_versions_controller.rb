class ProjectVersionsController < ApplicationController

  def new
  end

  def show

    @project_version = ProjectVersion.find(params[:id])
    @new_project_version = ProjectVersion.new
    @new_financial_filter = FinancialFilter.new
    @financial_filters = @project_version.financial_filters
    @project = @project_version.project
    @accepted_companies_for_manual_review = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @accepted_companies_for_internet_review = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: true, accepted_for_internet_review: true).sort_by(&:"BvD ID number")
    @unset_companies_trade_description = Company.where(project_version_id: @project_version.id, unset_trade_description: true, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @unset_companies_internet_review = Company.where(project_version_id: @project_version.id, unset_internet_review: true, accepted_for_internet_review: true, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @accepted_companies = Company.where(project_version_id: @project_version.id, accepted: true).sort_by(&:"BvD ID number")
    @unset_companies = @unset_companies_trade_description + @unset_companies_internet_review

    # gon.unset_companies = @unset_companies
  end

  def create
    @new_project_version = ProjectVersion.new(project_version_params)
    @new_project_version.open_tab = 'Versions'
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
