module FaresHelper
  def grouped_departure_options
    grouped = {}

    Fare.select(:departure, :departure_furigana).distinct.order(:departure_furigana).each do |fare|
      furigana = fare.departure_furigana.to_s.strip
      head = furigana[0] || "その他"

      group =
        case head
        when /[あ-お]/ then "あ行"
        when /[か-ご]/ then "か行"
        when /[さ-ぞ]/ then "さ行"
        when /[た-ど]/ then "た行"
        when /[な-の]/ then "な行"
        when /[は-ぽ]/ then "は行"
        when /[ま-も]/ then "ま行"
        when /[や-よ]/ then "や行"
        when /[ら-ろ]/ then "ら行"
        when /[わ-ん]/ then "わ行"
        when /[a-e]/i then "A〜E"
        when /[f-j]/i then "F〜J"
        when /[k-o]/i then "K〜O"
        when /[p-t]/i then "P〜T"
        when /[u-z]/i then "U〜Z"
        else "その他"
        end

      grouped[group] ||= []
      grouped[group] << { label: fare.departure, value: fare.departure, furigana: fare.departure_furigana }
    end

    group_order = %w[あ行 か行 さ行 た行 な行 は行 ま行 や行 ら行 わ行 A〜E F〜J K〜O P〜T U〜Z その他]
    grouped.sort_by { |group, _| group_order.index(group) || 999 }.to_h
  end

  def haversine_distance(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    rkm = 6371 # 地球半径(km)
    dlat_rad = (lat2 - lat1) * rad_per_deg
    dlon_rad = (lon2 - lon1) * rad_per_deg

    lat1_rad, lon1_rad = lat1 * rad_per_deg, lon1 * rad_per_deg
    lat2_rad, lon2_rad = lat2 * rad_per_deg, lon2 * rad_per_deg

    a = Math.sin(dlat_rad / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

    (rkm * c).round
  end
end


