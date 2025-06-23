module ApplicationHelper
  def sort_link(column, label)
    current_column = params[:sort]
    current_direction = params[:direction]
    new_direction = (current_column == column && current_direction == "asc") ? "desc" : "asc"

    # CSSクラスを追加（現在のソート対象かどうか）
    css_class = "sortable"
    css_class += " sort-asc" if current_column == column && current_direction == "asc"
    css_class += " sort-desc" if current_column == column && current_direction == "desc"

    # anonymous パラメータを含めて現在の状態を保持
    permitted_params = params.permit(:departure, :arrival, :anonymous)
    link_params = permitted_params.merge(sort: column, direction: new_direction)

    # ソートリンクを生成
    link_to label, link_params, class: css_class
  end
end
