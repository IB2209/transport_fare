// turbo.min.js（簡易版：Turboの主要機能に対応）
(function(){
  const Turbo = {
    start() {
      document.addEventListener("submit", (event) => {
        const form = event.target;
        if (form.hasAttribute("data-turbo")) {
          event.preventDefault();
          fetch(form.action, {
            method: form.method,
            body: new FormData(form),
            headers: { "Accept": "text/vnd.turbo-stream.html" }
          })
          .then(response => response.text())
          .then(html => {
            const template = document.createElement("template");
            template.innerHTML = html;
            const streamElements = template.content.querySelectorAll("turbo-stream");
            streamElements.forEach(el => Turbo.StreamActions[el.getAttribute("action")]({
              target: "#" + el.getAttribute("target"),
              template: el.innerHTML
            }));
          });
        }
      });
    },
    StreamActions: {
      replace({ target, template }) {
        const el = document.querySelector(target);
        if (el) el.outerHTML = template;
      },
      append({ target, template }) {
        const el = document.querySelector(target);
        if (el) el.insertAdjacentHTML("beforeend", template);
      },
      prepend({ target, template }) {
        const el = document.querySelector(target);
        if (el) el.insertAdjacentHTML("afterbegin", template);
      },
      remove({ target }) {
        const el = document.querySelector(target);
        if (el) el.remove();
      }
    }
  };

  window.Turbo = Turbo;
  document.addEventListener("DOMContentLoaded", () => {
    Turbo.start();
  });
})();
