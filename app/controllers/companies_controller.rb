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
    define_next_previous_companies(@company)
    @company.update(selection_params)
    @accepted_companies_for_manual_review = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @accepted_companies_for_internet_review = Company.where(project_version_id: @project_version.id, accepted_for_internet_review: true).sort_by(&:"BvD ID number")
    @unset_companies_trade_description = Company.where(project_version_id: @project_version.id, unset_trade_description: true).sort_by(&:"BvD ID number")
    @unset_companies_internet_review = Company.where(project_version_id: @project_version.id, unset_internet_review: true).sort_by(&:"BvD ID number")
    @accepted_companies = Company.where(project_version_id: @project_version.id, accepted: true).sort_by(&:"BvD ID number")
    @unset_companies = @unset_companies_trade_description + @unset_companies_internet_review
    if @project_version.open_tab = 'Trade description review'
      if selection_params[:accepted_for_internet_review] == 'true'
        @company.unset_trade_description = false
        @company.unrelated_activity = false
        @company.group = false
        @company.unrelated_function = false
      elsif selection_params[:unrelated_function] == 'true' || selection_params[:unrelated_activity] == 'true' || selection_params[:group] == 'true' || selection_params[:lack_information] == 'true'
        @company.unset_trade_description = false
        @company.accepted_for_internet_review = false
      else
        @company.unset_trade_description = true unless @company.unrelated_function? || @company.unrelated_activity? || @company.group? || @company.lack_information?
      end
    end
    if @company.save
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
  end

  private

  def selection_params
    params.require(:company).permit(:unrelated_activity, :lack_information, :unrelated_function, :group, :accepted_for_internet_review, :trade_description_en, :comment, :accepted)
  end

  def define_next_previous_companies(company)
    @accepted_companies_for_manual_review = Company.where(project_version_id: company.project_version.id, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @accepted_companies_for_internet_review = Company.where(project_version_id: company.project_version.id, accepted_for_internet_review: true).sort_by(&:"BvD ID number")
    if company.accepted_for_internet_review?
      @index = @accepted_companies_for_internet_review.index(company)
      @next_company = @accepted_companies_for_internet_review[@index+1]
        if @next_company.nil?
          @next_company = @accepted_companies_for_internet_review[0]
        end
      @previous_company = @accepted_companies_for_internet_review[@index-1]
    else
      @index = @accepted_companies_for_manual_review.index(company)
      @next_company = @accepted_companies_for_manual_review[@index+1]
        if @next_company.nil?
          @next_company = @accepted_companies_for_manual_review[0]
        end
      @previous_company = @accepted_companies_for_manual_review[@index-1]
    end
  end


end
