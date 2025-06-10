// app/javascript/controllers/select2_init_controller.js
import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import "select2"

export default class extends Controller {
  connect() {
    const $departure = $('#departure-select')
    const $arrival = $('#arrival-select')

    if ($departure.length) {
      $departure.select2({
        width: '100%',
        placeholder: "出発地を選択",
        allowClear: true,
        language: {
          inputTooShort: () => "キーワードを入力",
          noResults: () => "一致する項目が見つかりません",
          searching: () => "検索中…"
        }
      })
    }

    if ($arrival.length) {
      $arrival.select2({
        width: '100%',
        placeholder: "到着地を選択",
        allowClear: true,
        language: {
          inputTooShort: () => "キーワードを入力",
          noResults: () => "一致する項目が見つかりません",
          searching: () => "検索中…"
        }
      })
    }

    $departure.add($arrival).on('select2:open', () => {
      setTimeout(() => {
        $('.select2-search__field').attr('placeholder', '検索')
      }, 0)
    })
  }
}
