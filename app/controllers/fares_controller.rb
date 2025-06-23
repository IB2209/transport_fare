require "nkf"
require "csv"

class FaresController < ApplicationController
  before_action :set_fare, only: [:show, :edit, :update, :destroy]

  def index
    # パラメータの許可（unpermitted warning対策）
    params.permit(:anonymous, :departure, :arrival, :sort, :direction)
  
    @fare = Fare.new
  
    # 並び替え可能なカラム一覧とデフォルト値設定
    sortable_columns = %w[departure_furigana arrival_furigana distance fare_small fare_medium fare_large]
    sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : "departure_furigana"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  
    # 選択されたフィルター項目
    @selected_departure = params[:departure]
    @selected_arrival   = params[:arrival]
  
    # 距離別（匿名）モードか地点別モードかで処理分岐
    if params[:anonymous] == "true"
      # 匿名モード（距離ベースのデータを表示：出発・到着が空のもの）
      @fares = Fare.where(departure: [nil, ''], arrival: [nil, ''])
                   .order("#{sort_column} #{sort_direction}")
    else
      # 地点別運賃モード（出発・到着が存在するデータ）
      @fares = Fare.where.not(departure: [nil, ''], arrival: [nil, ''])
  
      # フィルター適用（"all" のときは無視）
      if @selected_departure.present? && @selected_departure != "all"
        @fares = @fares.where(departure: @selected_departure)
      end
      if @selected_arrival.present? && @selected_arrival != "all"
        @fares = @fares.where(arrival: @selected_arrival)
      end
  
      # 並び替え適用
      @fares = @fares.order("#{sort_column} #{sort_direction}")
    end
  
    # セレクトボックス用オプション生成（グループ化）
    @grouped_departure_options = grouped_furigana_options(:departure, :departure_furigana)
    @grouped_arrival_options   = grouped_furigana_options(:arrival, :arrival_furigana)
  end
  
  def search
    @selected_departure = params[:departure]
    @selected_arrival = params[:arrival]
  
    # 地点検索用
    @fares = Fare.all
    @fares = @fares.where(departure: @selected_departure) if @selected_departure.present? && @selected_departure != "all"
    @fares = @fares.where(arrival: @selected_arrival) if @selected_arrival.present? && @selected_arrival != "all"
    @grouped_fares = @fares.group_by { |f| [f.departure, f.arrival] }
  
    # セレクトボックス用
    @grouped_departure_options = grouped_furigana_options(:departure, :departure_furigana)
    @grouped_arrival_options = grouped_furigana_options(:arrival, :arrival_furigana)
  
    # 距離検索用
    if params[:distance].present?
      @distance = params[:distance].to_f
    
      # 10km刻みで切り上げ
      rounded_distance = (@distance / 10).ceil * 10

      @fare_distance_record = Fare.find_by(distance: rounded_distance)
    end
    
  end
  

  def import
    if params[:file].present?
      CsvImporter::FareImporter.import(params[:file])
      redirect_to fares_path, notice: "CSVからインポートしました"
    else
      redirect_to fares_path, alert: "CSVファイルを選択してください"
    end
  end

  def import_distance_csv
    if params[:file].present?
      CsvImporter::FareImporter.import(params[:file])
      redirect_to fares_path(anonymous: true), notice: "距離別CSVデータをインポートしました"
    else
      redirect_to fares_path, alert: "ファイルが選択されていません"
    end
  end
  
  
  

  def create
    @fare = Fare.new(fare_params)
    set_furigana_if_blank(@fare)

    if @fare.save
      redirect_to fares_path, notice: "運賃を登録しました。"
    else
      @fares = Fare.order(:departure_furigana, :arrival_furigana)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    set_furigana_if_blank(@fare)

    if @fare.update(fare_params)
      redirect_to fare_path(@fare), notice: "運賃を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fare.destroy
    redirect_to fares_path, notice: "運賃を削除しました。"
  end

  private

  def set_fare
    @fare = Fare.find(params[:id])
  end

  def fare_params
    params.require(:fare).permit(:departure, :arrival, :distance, :fare_small, :fare_medium, :fare_large, :departure_furigana, :arrival_furigana)
  end

  def set_furigana_if_blank(fare)
    fare.departure_furigana ||= normalize_kana(fare.departure)
    fare.arrival_furigana   ||= normalize_kana(fare.arrival)
  end

  def normalize_kana(text)
    NKF.nkf('-w -Z1 -h2', text.to_s.strip).tr("ァ-ン", "ぁ-ん")
  end

  def grouped_furigana_options(field, furigana_field)
    grouped = {}

    Fare.select(field, furigana_field).distinct.order(furigana_field).each do |fare|
      furigana = normalize_kana(fare.send(furigana_field).to_s.strip)
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
      grouped[group] << {
        label: fare.send(field),
        value: fare.send(field),
        furigana: furigana
      }
    end

    group_order = %w[あ行 か行 さ行 た行 な行 は行 ま行 や行 ら行 わ行 A〜E F〜J K〜O P〜T U〜Z その他]
    grouped.sort_by { |group, _| group_order.index(group) || 999 }.to_h
  end
end
