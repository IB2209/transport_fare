class Fare < ApplicationRecord
  validates :departure, :arrival, :fare_small, :fare_medium, :fare_large, presence: true

  def departure_group
    case departure_furigana.to_s[0]
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
    when /[a-eA-E]/ then "A〜E"
    when /[f-jF-J]/ then "F〜J"
    when /[k-oK-O]/ then "K〜O"
    when /[p-tP-T]/ then "P〜T"
    when /[u-zU-Z]/ then "U〜Z"
    else "その他"
    end
  end
end
