# Pin npm packages by running ./bin/importmap

pin "application", to: "application.js"
pin "d3", to: "https://cdn.skypack.dev/d3@7"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
