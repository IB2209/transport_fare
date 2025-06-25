import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import "select2"

export default class extends Controller {
  connect() {
    const $departure = $('#departure-select')
    const $arrival = $('#arrival-select')

    const commonOptions = {
      width: '100%',
      placeholder: "選択してください",
      allowClear: true,
      language: {
        inputTooShort: () => "キーワードを入力",
        noResults: () => "一致する項目が見つかりません",
        searching: () => "検索中…"
      },
      matcher: function(params, data) {
        if ($.trim(params.term) === '') return data;
        const term = params.term.toLowerCase();
        const text = data.text.toLowerCase();
        const furigana = $(data.element).data('furigana')?.toLowerCase() || '';
        if (text.includes(term) || furigana.includes(term)) {
          return data;
        }
        return null;
      }
    }

    if ($departure.length) $departure.select2(commonOptions)
    if ($arrival.length) $arrival.select2(commonOptions)

    $departure.add($arrival).on('select2:open', () => {
      setTimeout(() => {
        $('.select2-search__field').attr('placeholder', '検索')
      }, 0)
    })
  }
}
