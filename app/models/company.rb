class Company < ApplicationRecord
  belongs_to :project_version

  require 'csv'

  def self.import(file, project_version_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.sheet(1).row(2)
    (3..spreadsheet.sheet(1).last_row).each do |i|
      row=Hash[[header,spreadsheet.sheet(1).row(i)].transpose]
      unless Company.exists?(project_version_id: project_version_id.to_i, "BvD ID number": row["BvD ID number"])
        company = Company.new
        company.project_version_id = project_version_id.to_i
        company.attributes = row.to_hash.slice(*Company.attribute_names)
        company.trade_description_en = row.to_hash["Trade description (English)"]
        company.trade_description_original = row.to_hash["Trade description (original language)"]
        company.turnover_year_1 = row.to_hash["Turnover #{company.project_version.year_1}"]
        company.turnover_year_2 = row.to_hash["Turnover #{company.project_version.year_2}"]
        company.turnover_year_3 = row.to_hash["Turnover #{company.project_version.year_3}"]
        company.EBIT_year_1 = row.to_hash["EBIT #{company.project_version.year_1}"]
        company.EBIT_year_2 = row.to_hash["EBIT #{company.project_version.year_2}"]
        company.EBIT_year_3 = row.to_hash["EBIT #{company.project_version.year_3}"]

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
        company.save!
      end
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
