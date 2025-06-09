import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-loading";

const application = Application.start();
const context = require.context(".", true, /\.js$/); // 現在のディレクトリ以下を対象
application.load(definitionsFromContext(context));

export { application };
