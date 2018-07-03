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
    if @project_version.open_tab == 'Trade description review'
      if selection_params[:accepted_for_internet_review] == 'true'
        @company.unset_trade_description = false
        @company.unrelated_activity = false
        @company.group = false
        @company.unrelated_function = false
        @company.unset_internet_review = true
      elsif selection_params[:unrelated_function] == 'true' || selection_params[:unrelated_activity] == 'true' || selection_params[:group] == 'true' || selection_params[:lack_information] == 'true'
        @company.unset_trade_description = false
        @company.accepted_for_internet_review = false
        @company.unset_internet_review = false
      else
        @company.unset_trade_description = true unless @company.unrelated_function? || @company.unrelated_activity? || @company.group? || @company.lack_information? || @company.accepted_for_internet_review?
      end
    elsif @project_version.open_tab == "Internet review"
      if selection_params[:accepted] == 'true'
        @company.unrelated_activity = false
        @company.group = false
        @company.unrelated_function = false
        @company.unset_internet_review = false
      elsif selection_params[:unrelated_function] == 'true' || selection_params[:unrelated_activity] == 'true' || selection_params[:group] == 'true' || selection_params[:lack_information] == 'true'
        @company.unset_internet_review = false
        @company.accepted = false
      else
        @company.unset_internet_review = true unless @company.unrelated_function? || @company.unrelated_activity? || @company.group? || @company.lack_information? || @company.accepted?
      end
    end
    if @company.save
      define_selection_count
      define_next_previous_companies(@company)
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

    if @project_version.open_tab == 'Trade description review'

      @index = @accepted_companies_for_manual_review.index(company)
      @next_company = @accepted_companies_for_manual_review[@index+1]
      @next_company = @accepted_companies_for_manual_review[0] if @next_company.nil?
      @previous_company = @accepted_companies_for_manual_review[@index-1]
      @previous_company = @accepted_companies_for_manual_review.last if @previous_company.nil?

    elsif @project_version.open_tab == 'Internet review'

      @index = @accepted_companies_for_internet_review.index(company)
      @next_company = @accepted_companies_for_internet_review[@index+1]
      @next_company = @accepted_companies_for_internet_review[0] if @next_company.nil?
      @previous_company = @accepted_companies_for_internet_review[@index-1]
      @previous_company = @accepted_companies_for_internet_review.last if @previous_company.nil?

    end
  end

  def define_selection_count
    @accepted_companies_for_manual_review = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @accepted_companies_for_internet_review = Company.where(project_version_id: @project_version.id, accepted_for_manual_review: true, accepted_for_internet_review: true).sort_by(&:"BvD ID number")
    @unset_companies_trade_description = Company.where(project_version_id: @project_version.id, unset_trade_description: true, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @unset_companies_internet_review = Company.where(project_version_id: @project_version.id, unset_internet_review: true, accepted_for_internet_review: true, accepted_for_manual_review: true).sort_by(&:"BvD ID number")
    @accepted_companies = Company.where(project_version_id: @project_version.id, accepted: true).sort_by(&:"BvD ID number")
    @unset_companies = @unset_companies_trade_description + @unset_companies_internet_review
  end
end
