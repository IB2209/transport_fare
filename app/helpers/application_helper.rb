module ApplicationHelper
  def sort_link(column, label)
    current_column = params[:sort]
    current_direction = params[:direction]
    new_direction = (current_column == column && current_direction == "asc") ? "desc" : "asc"

    # CSSクラスを追加（現在のソート対象かどうか）
    css_class = "sortable"
    css_class += " sort-asc" if current_column == column && current_direction == "asc"
    css_class += " sort-desc" if current_column == column && current_direction == "desc"

    # ソートリンクを生成（既存の検索条件も保持）
    link_to label, params.permit(:departure, :arrival).merge(sort: column, direction: new_direction), class: css_class
  end
end
