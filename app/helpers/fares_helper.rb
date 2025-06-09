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
end
