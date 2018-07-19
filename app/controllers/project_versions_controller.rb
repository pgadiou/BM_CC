class ProjectVersionsController < ApplicationController

require 'descriptive_statistics'

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
    @accepted_companies = Company.where(project_version_id: @project_version.id, accepted_for_internet_review: true, accepted_for_manual_review: true, accepted: true).sort_by(&:"BvD ID number")
    @unset_companies = @unset_companies_trade_description + @unset_companies_internet_review
    @rejected_internet_review = Company.where(project_version_id: @project_version.id, accepted_for_internet_review: true, accepted: false).sort_by(&:"BvD ID number")
    @rejected_trade_description_review = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: true, accepted_for_internet_review: false).sort_by(&:"BvD ID number")
    @rejected_financial_filters = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: false).sort_by(&:"BvD ID number")
    @unset_companies = @unset_companies_trade_description + @unset_companies_internet_review

    define_overall_final_sample_results

    define_final_pli_results

    respond_to do |format|
      format.html
      format.csv
      format.xls
    end


    # gon.unset_companies = @unset_companies
  end

  def create
    @new_project_version = ProjectVersion.new(project_version_params)
    @new_project_version.open_tab = 'Versions'
    @new_project_version.year_2 = @new_project_version.year_1 + 1
    @new_project_version.year_3 = @new_project_version.year_2 + 1
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

  def define_overall_final_sample_results
    if @accepted_companies.empty?
      @ros_results_final = []
      if @unset_companies.empty?
        @project_version.companies.each do |company|
          @ros_results_final << company.ros_avg if company.ros_avg
        end
      else
        @unset_companies.each do |company|
          @ros_results_final << company.ros_avg if company.ros_avg
        end
      end
    else
      @ros_results_final = []
      @accepted_companies.each do |company|
        @ros_results_final << company.ros_avg if company.ros_avg
      end
    end
  end

  def define_final_pli_results
    @accepted_companies_min = @ros_results_final.min unless @ros_results_final.empty?
    @accepted_companies_q1 = @ros_results_final.percentile(25) unless @ros_results_final.empty?
    @accepted_companies_median = @ros_results_final.median unless @ros_results_final.empty?
    @accepted_companies_q3 = @ros_results_final.percentile(75) unless @ros_results_final.empty?
    @accepted_companies_max = @ros_results_final.max unless @ros_results_final.empty?
  end

  private

  def project_version_params
    params.require(:project_version).permit(:description, :year_1,:pli, :project_id)
  end

end
