class FinancialFiltersController < ApplicationController

  def new
  end

  def create
    @new_financial_filter = FinancialFilter.new(financial_filter_params)
    @project_version = @new_financial_filter.project_version
    if @new_financial_filter.save
      if @new_financial_filter.description == "losses"
        if @new_financial_filter.three_years
          @project_version.companies.each do |company|
            if (company["EBIT 2011"] < 0) || (company["EBIT 2012"] < 0) || (company["EBIT 2013"] < 0)
              company.losses = true
              company.accepted_for_manual_review = false
              company.save
            end
          end
        else
          @project_version.companies.each do |company|
            if ((company["EBIT 2011"] < 0) && (company["EBIT 2012"] < 0)) || ((company["EBIT 2012"] < 0) && (company["EBIT 2013"] < 0))
              company.losses = true
              company.accepted_for_manual_review = false
              company.save
            end
          end
        end
      end

      if @new_financial_filter.description == "turnover"
        if @new_financial_filter.three_years
          @project_version.companies.each do |company|
            if (company["Turnover 2011"] < @new_financial_filter.minimum_turnover) || (company["Turnover 2012"] < @new_financial_filter.minimum_turnover) || (company["Turnover 2013"] < @new_financial_filter.minimum_turnover)
              company.turnover = true
              company.accepted_for_manual_review = false
              company.save
            end
          end
        else
          @project_version.companies.each do |company|
            if ((company["Turnover 2011"] < @new_financial_filter.minimum_turnover) && (company["Turnover 2012"] < @new_financial_filter.minimum_turnover)) || ((company["Turnover 2012"] < @new_financial_filter.minimum_turnover) && (company["Turnover 2013"] < @new_financial_filter.minimum_turnover))
              company.turnover = true
              company.accepted_for_manual_review = false
              company.save
            end
          end
        end
      end

      if @new_financial_filter.description == "data availability"
        if @new_financial_filter.three_years
          @project_version.companies.each do |company|
            unless (company["EBIT 2011"] != 0) || (company["EBIT 2012"] != 0) || (company["EBIT 2013"] != 0)
              company.lack_financials = true
              company.accepted_for_manual_review = false
              company.save
            end
          end
        else
          @project_version.companies.each do |company|
            unless ((company["EBIT 2011"] != 0) && (company["EBIT 2012"] != 0)) || ((company["EBIT 2012"] != 0) && (company["EBIT 2013"] != 0)) || ((company["EBIT 2012"] != 0) && (company["EBIT 2013"] != 0))
              company.lack_financials = true
              company.accepted_for_manual_review = false
              company.save
            end
          end
        end
      end

      redirect_to project_version_path(@project_version)
    end
  end

  def destroy
    @financial_filter = FinancialFilter.find(params[:id])
    @project_version = @financial_filter.project_version
    @financial_filter.destroy

    if @financial_filter.description == "losses"

      @project_version.companies.each do |company|
        company.losses = false
        unless company.accepted || company.losses || company.turnover || company.lack_financials || company.unrelated_activity || company.lack_information|| company.unrelated_function || company.group
          company.accepted_for_manual_review = true
        end
        company.save
      end

    elsif @financial_filter.description == "turnover"

      @project_version.companies.each do |company|
        company.turnover = false
        unless company.accepted || company.losses || company.turnover || company.lack_financials || company.unrelated_activity || company.lack_information|| company.unrelated_function || company.group
          company.accepted_for_manual_review = true
        end
        company.save
      end

    elsif @financial_filter.description == "data availability"

      @project_version.companies.each do |company|
        company.lack_financials = false
        unless company.accepted || company.losses || company.turnover || company.lack_financials || company.unrelated_activity || company.lack_information|| company.unrelated_function || company.group
          company.accepted_for_manual_review = true
        end
        company.save
      end

    end

    #@user = current_user
    #@profile = @user.profile
    redirect_to project_version_path(@project_version)
  end


  private

  def financial_filter_params
    params.require(:financial_filter).permit(:description, :project_version_id, :three_years, :minimum_turnover)
  end

end
