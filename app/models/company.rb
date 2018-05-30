class Company < ApplicationRecord
  belongs_to :project

  require 'csv'

  def self.import(file, project_version_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(2)
    (3..spreadsheet.last_row).each do |i|
      row=Hash[[header,spreadsheet.row(i)].transpose]
      company = find_by_id(row["id"])||new
      company.project_version_id = project_version_id.to_i
      company.attributes = row.to_hash
      company.save!
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
