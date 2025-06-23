require 'csv'

module CsvImporter
  class FareImporter
    def self.import(file)
      Rails.logger.debug("🚀 CSVインポート開始: #{file.original_filename}")

      CSV.foreach(file.path, headers: true, encoding: 'bom|utf-8') do |row|
        raw = row.to_h.transform_keys { |k| k.to_s.strip.gsub("\uFEFF", "") }
                      .transform_values { |v| v.to_s.strip }

        Rails.logger.debug("📄 CSV行データ: #{raw.inspect}")

        begin
          if raw["distance"].present? && raw["departure"].blank? && raw["arrival"].blank?
            # -------------------------------
            # パターン②：距離 + 金額のみ（匿名）
            # -------------------------------
            distance = sanitize_float(raw["distance"])
            next unless distance.present?

            fare = Fare.find_or_initialize_by(distance: distance, departure: nil, arrival: nil)
            fare.fare_small  = sanitize_number(raw["fare_small"]) if raw.key?("fare_small")
            fare.fare_medium = sanitize_number(raw["fare_medium"]) if raw.key?("fare_medium")
            fare.fare_large  = sanitize_number(raw["fare_large"]) if raw.key?("fare_large")

          else
            # -------------------------------
            # パターン①：地点名あり（通常）
            # -------------------------------
            departure = raw["departure"]
            arrival   = raw["arrival"]
            next if departure.blank? || arrival.blank?

            fare = Fare.find_or_initialize_by(departure: departure, arrival: arrival)

            fare.departure_furigana = raw["departure_furigana"].presence
            fare.arrival_furigana   = raw["arrival_furigana"].presence
            fare.distance           = sanitize_float(raw["distance"]) if raw.key?("distance")
            fare.fare_small         = sanitize_number(raw["fare_small"]) if raw.key?("fare_small")
            fare.fare_medium        = sanitize_number(raw["fare_medium"]) if raw.key?("fare_medium")
            fare.fare_large         = sanitize_number(raw["fare_large"]) if raw.key?("fare_large")
          end

          # -------------------------------
          # 保存処理 + ログ出力
          # -------------------------------
          if fare.changed?
            if fare.save
              Rails.logger.debug("✅ CSV登録成功: #{fare.inspect}")
            else
              Rails.logger.error("❌ CSV登録失敗: #{fare.errors.full_messages.join(', ')}")
            end
          else
            Rails.logger.debug("⏭ CSVスキップ（変更なし）: #{fare.inspect}")
          end

        rescue => e
          Rails.logger.error("❗ CSV処理中エラー: #{e.class} - #{e.message}")
          Rails.logger.error("🔍 該当行データ: #{raw.inspect}")
        end
      end

      Rails.logger.debug("🏁 CSVインポート完了")
    end

    # 数字（整数）変換：¥やカンマを除去して整数化
    def self.sanitize_number(value)
      return nil if value.blank?
      cleaned = value.to_s.gsub(/[^\d]/, "")
      Rails.logger.debug("🔢 数値変換: #{value.inspect} => #{cleaned}")
      cleaned.to_i
    end

    # 小数点付き数値変換（距離用）
    def self.sanitize_float(value)
      return nil if value.blank?
      cleaned = value.to_s.gsub(/[^\d.]/, "")
      Rails.logger.debug("📏 距離変換: #{value.inspect} => #{cleaned}")
      cleaned.to_f
    end
  end
end
