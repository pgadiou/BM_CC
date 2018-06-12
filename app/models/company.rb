class Company < ApplicationRecord
  belongs_to :project_version

  require 'csv'

  def self.import(file, project_version_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(2)
    (3..spreadsheet.last_row).each do |i|
      row=Hash[[header,spreadsheet.row(i)].transpose]
      unless Company.exists?(project_version_id: project_version_id.to_i, "BvD ID number": row["BvD ID number"])
        company = Company.new
        company.project_version_id = project_version_id.to_i
        company.attributes = row.to_hash.slice(*Company.attribute_names)
        company.trade_description_en = row.to_hash["Trade description (English)"]
        company.trade_description_original = row.to_hash["Trade description (original language)"]
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
