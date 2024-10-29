require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module WellAcademy
  class Application < Rails::Application
    config.load_defaults 7.2

    config.autoload_lib(ignore: %w[assets tasks])
    config.active_job.queue_adapter = :sidekiq

  end
end
