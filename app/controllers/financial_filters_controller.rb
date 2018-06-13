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
              company.unset = false
              company.save
            end
          end
        else
          @project_version.companies.each do |company|
            if ((company["EBIT 2011"] < 0) && (company["EBIT 2012"] < 0)) || ((company["EBIT 2012"] < 0) && (company["EBIT 2013"] < 0))
              company.losses = true
              company.unset = false
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
    #@user = current_user
    #@profile = @user.profile
    redirect_to project_version_path(@project_version)
  end


  private

  def financial_filter_params
    params.require(:financial_filter).permit(:description, :project_version_id, :three_years)
  end

end
