# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'

# UI Libraries
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin 'trix' # @2.1.15
pin '@rails/actiontext', to: '@rails--actiontext.js' # @8.0.200
pin 'chartkick' # @5.0.1
pin 'Chart.bundle', to: 'Chart.bundle.js'
pin '@rails/request.js', to: '@rails--request.js.js' # @0.0.12

# Utils
pin 'lodash' # @4.17.21
pin 'luxon' # @3.6.1
pin '@rails/activestorage', to: '@rails--activestorage.js' # @8.0.200
pin 'chart.js' # @4.5.0
pin '@kurkle/color', to: '@kurkle--color.js' # @0.3.4
