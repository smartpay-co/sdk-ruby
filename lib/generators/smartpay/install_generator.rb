# frozen_string_literal: true

require "rails/generators"

module Smartpay
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def install
      template "initializer.rb", "config/initializers/smartpay.rb"
      template "controller.rb", "app/controllers/smartpays_controller.rb"
      directory "views", "app/views/smartpays"

      route "resources :smartpays, only: [:index, :create]"
    end
  end
end
