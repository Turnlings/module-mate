# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', to: 'application.js'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin 'chartkick', to: 'https://cdn.jsdelivr.net/npm/chartkick@5.0.1/dist/chartkick.min.js'
pin 'chart.js', to: 'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js'
pin 'chartjs-adapter-date-fns', to: 'https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js'
pin "clipboard" # @2.0.11
