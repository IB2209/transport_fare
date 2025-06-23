class Fare < ApplicationRecord
  # =============================
  # バリデーション
  # =============================

  # 地点データがある場合、出発・到着地は必須（距離だけのときは不要）
  with_options if: -> { departure.present? || arrival.present? } do
    validates :departure, presence: { message: "を入力してください" }
    validates :arrival, presence: { message: "を入力してください" }
  end

  # 運賃はすべて必須（地点別・距離別のどちらでも）
  validates :fare_small,  presence: { message: "（小型）を入力してください" }
  validates :fare_medium, presence: { message: "（中型）を入力してください" }
  validates :fare_large,  presence: { message: "（大型）を入力してください" }

  # =============================
  # インスタンスメソッド：出発地ふりがなグループ
  # =============================
  def departure_group
    classify_furigana(departure_furigana)
  end

  # =============================
  # インスタンスメソッド：到着地ふりがなグループ
  # =============================
  def arrival_group
    classify_furigana(arrival_furigana)
  end

  private

  # =============================
  # 共通：ふりがな文字からグループを判定
  # =============================
  def classify_furigana(furigana)
    case furigana.to_s[0]
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
