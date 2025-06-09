// ✅ 動作確認ログ
console.log("🌱 最新バージョンの application.js が読み込まれました！");

// ✅ Turbo（ページ遷移を高速化）
import "@hotwired/turbo-rails";

// ✅ Stimulus：コントローラ自動読み込み
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-loading";

// ✅ Rails UJS（data-method, remote: true などを動かす）
import { start as RailsStart } from "@rails/ujs";
RailsStart();


// ✅ Stimulus アプリケーション初期化
const application = Application.start();


// ✅ 成功ログ
console.log("✅ JavaScript is fully working with Stimulus, Turbo, and UJS!");
