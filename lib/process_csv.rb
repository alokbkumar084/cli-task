# frozen_string_literal: true

require 'csv'
require_relative 'location_validator'

class ProcessCsv
  attr_reader :file_path, :verified_records

  def initialize(file_path)
    @file_path = file_path
    @verified_records = []
  end

  def process
    CSV.foreach(file_path, headers: true) do |row|
      email, first_name, last_name = row.values_at('Email', 'First Name', 'Last Name')

      next unless [email, first_name, last_name].all? { |field| field && !field.strip.empty? }

      valid_residential = validate_location(row, 'Residential Address')
      valid_postal = validate_location(row, 'Postal Address')

      verified_records << row.to_csv if valid_residential && valid_postal
    end

    verified_records
  end

  private

  def validate_location(row, address_type)
    LocationValidator.validate?(
      row["#{address_type} Locality"],
      row["#{address_type} State"],
      row["#{address_type} Postcode"]
    )
  end
end
