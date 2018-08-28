class Company < ApplicationRecord
  belongs_to :project_version

  require 'csv'

  def self.import(file, project_version_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.sheet(1).row(1)
    project_version = ProjectVersion.find(project_version_id.to_i)
    imported_companies_ids = []
    former_companies_ids = Company.where(project_version_id: project_version_id).pluck(:"BvD ID number")
    (3..spreadsheet.sheet(1).last_row).each do |i|
      row=Hash[[header,spreadsheet.sheet(1).row(i)].transpose]
      imported_companies_ids << row["BvD ID number"]
      unless Company.exists?(project_version_id: project_version_id.to_i, "BvD ID number": row["BvD ID number"])
        company = Company.new
        company.project_version_id = project_version_id.to_i
        company.attributes = row.to_hash.slice(*Company.attribute_names)
        company.trade_description_en = row.to_hash["Trade description (English)"]
        company.trade_description_original = row.to_hash["Trade description (original language)"]
        company.turnover_year_1 = row.to_hash["Operating revenue (Turnover)\nth EUR\n#{company.project_version.year_1}"]
        company.turnover_year_2 = row.to_hash["Operating revenue (Turnover)\nth EUR\n#{company.project_version.year_2}"]
        company.turnover_year_3 = row.to_hash["Operating revenue (Turnover)\nth EUR\n#{company.project_version.year_3}"]
        company.EBIT_year_1 = row.to_hash["Operating P/L [=EBIT]\nth EUR\n#{company.project_version.year_1}"]
        company.EBIT_year_2 = row.to_hash["Operating P/L [=EBIT]\nth EUR\n#{company.project_version.year_2}"]
        company.EBIT_year_3 = row.to_hash["Operating P/L [=EBIT]\nth EUR\n#{company.project_version.year_3}"]

        sum_EBIT = 0
        sum_turnover = 0

        if company.turnover_year_1 != 0 && company.EBIT_year_1 != 0
          sum_EBIT += company.EBIT_year_1
          sum_turnover += company.turnover_year_1
          company.ros_1 = (company.EBIT_year_1.to_f / company.turnover_year_1.to_f).to_f
          company.fcmu_1 = (company.EBIT_year_1.to_f / (company.turnover_year_1.to_f - company.EBIT_year_1.to_f)).to_f
        end
        if company.turnover_year_2 != 0 && company.EBIT_year_2 != 0
          sum_EBIT += company.EBIT_year_2
          sum_turnover += company.turnover_year_2
          company.ros_2 = (company.EBIT_year_2.to_f / company.turnover_year_2.to_f).to_f
          company.fcmu_2 = (company.EBIT_year_2.to_f / (company.turnover_year_2.to_f - company.EBIT_year_2.to_f)).to_f
        end
        if company.turnover_year_3 != 0 && company.EBIT_year_3 != 0
          sum_EBIT += company.EBIT_year_3
          sum_turnover += company.turnover_year_3
          company.ros_3 = (company.EBIT_year_3.to_f / company.turnover_year_3.to_f).to_f
          company.fcmu_3 = (company.EBIT_year_3.to_f / (company.turnover_year_3.to_f - company.EBIT_year_3.to_f)).to_f
        end
        if sum_EBIT != 0 && sum_turnover != 0
          company.ros_avg = (sum_EBIT.to_f / sum_turnover.to_f).to_f
          company.fcmu_avg = ((sum_turnover.to_f - sum_EBIT.to_f) / sum_turnover.to_f).to_f
        end

      else
        company = Company.where(project_version_id: project_version_id.to_i, "BvD ID number": row["BvD ID number"]).first
        company.attributes = row.to_hash.slice(*Company.attribute_names)
        company.trade_description_en = row.to_hash["Trade description (English)"]
        company.trade_description_original = row.to_hash["Trade description (original language)"]
        company.turnover_year_1 = row.to_hash["Operating revenue (Turnover)\nth EUR\n#{company.project_version.year_1}"]
        company.turnover_year_2 = row.to_hash["Operating revenue (Turnover)\nth EUR\n#{company.project_version.year_2}"]
        company.turnover_year_3 = row.to_hash["Operating revenue (Turnover)\nth EUR\n#{company.project_version.year_3}"]
        company.EBIT_year_1 = row.to_hash["Operating P/L [=EBIT]\nth EUR\n#{company.project_version.year_1}"]
        company.EBIT_year_2 = row.to_hash["Operating P/L [=EBIT]\nth EUR\n#{company.project_version.year_2}"]
        company.EBIT_year_3 = row.to_hash["Operating P/L [=EBIT]\nth EUR\n#{company.project_version.year_3}"]

        sum_EBIT = 0
        sum_turnover = 0

        if company.turnover_year_1 != 0 && company.EBIT_year_1 != 0
          sum_EBIT += company.EBIT_year_1
          sum_turnover += company.turnover_year_1
          company.ros_1 = (company.EBIT_year_1.to_f / company.turnover_year_1.to_f).to_f
          company.fcmu_1 = (company.EBIT_year_1.to_f / (company.turnover_year_1.to_f - company.EBIT_year_1.to_f)).to_f
        end
        if company.turnover_year_2 != 0 && company.EBIT_year_2 != 0
          sum_EBIT += company.EBIT_year_2
          sum_turnover += company.turnover_year_2
          company.ros_2 = (company.EBIT_year_2.to_f / company.turnover_year_2.to_f).to_f
          company.fcmu_2 = (company.EBIT_year_2.to_f / (company.turnover_year_2.to_f - company.EBIT_year_2.to_f)).to_f
        end
        if company.turnover_year_3 != 0 && company.EBIT_year_3 != 0
          sum_EBIT += company.EBIT_year_3
          sum_turnover += company.turnover_year_3
          company.ros_3 = (company.EBIT_year_3.to_f / company.turnover_year_3.to_f).to_f
          company.fcmu_3 = (company.EBIT_year_3.to_f / (company.turnover_year_3.to_f - company.EBIT_year_3.to_f)).to_f
        end
        if sum_EBIT != 0 && sum_turnover != 0
          company.ros_avg = (sum_EBIT.to_f / sum_turnover.to_f).to_f
          company.fcmu_avg = ((sum_turnover.to_f - sum_EBIT.to_f) / sum_turnover.to_f).to_f
        end

      end

      unless project_version.financial_filters.empty?
        project_version.financial_filters.each do |filter|
          if filter.description == "losses"
            if filter.three_years
              if (company.EBIT_year_1 < 0) || (company.EBIT_year_2 < 0) || (company.EBIT_year_3 < 0)
                company.losses = true
                company.accepted_for_manual_review = false
              end
            else
              if ((company.EBIT_year_1 < 0) && (company.EBIT_year_2 < 0)) || ((company.EBIT_year_2 < 0) && (company.EBIT_year_3 < 0))
                company.losses = true
                company.accepted_for_manual_review = false
              end
            end
          end

          if filter.description == "turnover"
            if filter.three_years
              if (company.turnover_year_1 < filter.minimum_turnover) || (company.turnover_year_2 < filter.minimum_turnover) || (company.turnover_year_3 < filter.minimum_turnover)
                company.turnover = true
                company.accepted_for_manual_review = false
              end
            else
              if ((company.turnover_year_1 < filter.minimum_turnover) && (company.turnover_year_2 < filter.minimum_turnover)) || ((company.turnover_year_2 < filter.minimum_turnover) && (company.turnover_year_3 < filter.minimum_turnover))
                company.turnover = true
                company.accepted_for_manual_review = false
              end
            end
          end

          if filter.description == "data availability"
            if filter.three_years
              unless (company["EBIT 2011"] != 0) || (company["EBIT 2012"] != 0) || (company["EBIT 2013"] != 0)
                company.lack_financials = true
                company.accepted_for_manual_review = false
              end
            end
          else
            unless ((company["EBIT 2011"] != 0) && (company["EBIT 2012"] != 0)) || ((company["EBIT 2012"] != 0) && (company["EBIT 2013"] != 0)) || ((company["EBIT 2012"] != 0) && (company["EBIT 2013"] != 0))
              company.lack_financials = true
              company.accepted_for_manual_review = false
            end
          end
        end
      end
      company.save!
    end
    companies_to_be_deleted = former_companies_ids - imported_companies_ids
    companies_to_be_deleted.each do |bvd_id|
      Company.where(project_version_id: project_version_id.to_i, "BvD ID number": bvd_id).first.destroy
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
    else raise 'Unknown file type: #{file.original_filename}'
    end
  end

end
