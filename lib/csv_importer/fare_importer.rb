require 'csv'

module CsvImporter
  class FareImporter
    def self.import(file)
      CSV.foreach(file.path, headers: true, encoding: 'bom|utf-8') do |row|
        # キーと値の前後空白・BOM除去
        raw = row.to_h.transform_keys { |k| k.to_s.strip.gsub("\uFEFF", "") }
                      .transform_values { |v| v.to_s.strip }

        fare_params = {
          departure:            raw["departure"].presence,
          departure_furigana:   raw["departure_furigana"].presence,
          arrival:              raw["arrival"].presence,
          arrival_furigana:     raw["arrival_furigana"].presence,
          distance:             sanitize_float(raw["distance"]),
          fare_small:           sanitize_number(raw["fare_small"]),
          fare_medium:          sanitize_number(raw["fare_medium"]),
          fare_large:           sanitize_number(raw["fare_large"])
        }

        Rails.logger.debug("読み込んだデータ: #{fare_params.inspect}")

        fare = Fare.new(fare_params)
        unless fare.save
          Rails.logger.error("CSVインポート失敗: #{fare.errors.full_messages.join(', ')}")
        end
      end
    end

    def self.sanitize_number(value)
      return nil if value.blank?
      value.to_s.gsub(/[^\d]/, "").to_i
    end

    def self.sanitize_float(value)
      return nil if value.blank?
      value.to_s.gsub(/[^\d.]/, "").to_f
    end
  end
end
