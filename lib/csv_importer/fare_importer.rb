require 'csv'

module CsvImporter
  class FareImporter
    def self.import(file)
      CSV.foreach(file.path, headers: true, encoding: 'UTF-8') do |row|
        fare_params = row.to_h.slice("departure", "arrival", "distance", "fare_small", "fare_medium", "fare_large")
        Fare.create!(fare_params)
      end
    end
  end
end
