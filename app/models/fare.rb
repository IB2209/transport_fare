class Fare < ApplicationRecord
  # =============================
  # バリデーション
  # =============================

  with_options if: -> { departure.present? || arrival.present? } do
    validates :departure, presence: { message: "を入力してください" }
    validates :arrival, presence: { message: "を入力してください" }
  end

  validates :fare_small,  presence: { message: "（小型）を入力してください" }
  validates :fare_medium, presence: { message: "（中型）を入力してください" }
  validates :fare_large,  presence: { message: "（大型）を入力してください" }

  # =============================
  # コールバック：保存前にふりがなを自動セット
  # =============================
  before_save :set_furigana

  # =============================
  # インスタンスメソッド：ふりがなグループ
  # =============================
  def departure_group
    classify_furigana(departure_furigana)
  end

  def arrival_group
    classify_furigana(arrival_furigana)
  end

  private

  # =============================
  # ふりがなを自動的に設定
  # =============================
  def set_furigana
    self.departure_furigana = normalize_kana(departure) if departure.present?
    self.arrival_furigana   = normalize_kana(arrival)   if arrival.present?
  end

  # =============================
  # カタカナ → ひらがな変換
  # =============================
  def normalize_kana(text)
    NKF.nkf('-w -Z1 -h2', text.to_s.strip).tr("ァ-ン", "ぁ-ん")
  end

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
